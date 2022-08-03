import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medkit_app/components/coustom_bottom_nav_bar.dart';
import 'package:medkit_app/controller/auth_controllerr.dart';
import 'package:medkit_app/controller/auth_services.dart';
import 'package:medkit_app/controller/get_controll.dart';
import 'package:medkit_app/enums.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/screens/doctor/doctor_screen.dart';
import 'package:medkit_app/size_config.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  static String routeName = "/message";
  final authC = FirebaseAuth.instance.currentUser;
  final login = Get.put(cLogin()).isLogin;
  @override
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              decoration: BoxDecoration(
                color: kWhite,
                boxShadow: shadowBOX,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 7,
                      ),
                      Text("RS CITRA HUSADA",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: kPrimaryColor)),
                      const Text(
                          'Konsultasikan kesehetanmu bersama \ndokter pilihanmu'),
                      const SizedBox(
                        height: 7,
                      )
                    ],
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    color: kPrimaryColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Get.toNamed(DoctorScreen.routname),
                      child: Container(
                        padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                        height: getProportionateScreenWidth(55),
                        width: getProportionateScreenWidth(55),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(57, 121, 121, 121),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            )
                          ],
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/ic_doctor.svg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.chatsStream(authC!.email.toString()),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.active) {
                  var listDocsChats = snapshot1.data!.docs;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: listDocsChats.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller
                            .friendStream(listDocsChats[index]["connection"]),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.active) {
                            var data = snapshot2.data!.data();
                            return data!["status"] == ""
                                ? ListTile(
                                    style: ListTileTheme.of(context).style,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    onTap: () => controller.goToChatRoom(
                                      "${listDocsChats[index].id}",
                                      authC!.email.toString(),
                                      listDocsChats[index]["connection"],
                                    ),
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.black26,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: data["photoUrl"] == "noimage"
                                            ? Image.asset(
                                                "assets/logo/noimage.png",
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                "${data["photoUrl"]}",
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    title: Text("${data["name"]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(color: kPrimaryColor)),
                                    subtitle: Text('${data["status"]}'),
                                    trailing: listDocsChats[index]
                                                ["total_unread"] ==
                                            0
                                        ? const SizedBox()
                                        : Chip(
                                            backgroundColor: kPrimaryColor,
                                            label: Text(
                                              "${listDocsChats[index]["total_unread"]}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(color: kWhite),
                                            ),
                                          ),
                                  )
                                : ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 5,
                                    ),
                                    onTap: () => controller.goToChatRoom(
                                      "${listDocsChats[index].id}",
                                      authC!.email.toString(),
                                      listDocsChats[index]["connection"],
                                    ),
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.black26,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: data["photoUrl"] == "noimage"
                                            ? Image.asset(
                                                "assets/logo/noimage.png",
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                "${data["photoUrl"]}",
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    title: Text(
                                      "${data["name"]}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${data["status"]}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    trailing: listDocsChats[index]
                                                ["total_unread"] ==
                                            0
                                        ? const SizedBox()
                                        : Chip(
                                            backgroundColor: kPrimaryColor,
                                            label: Text(
                                              "${listDocsChats[index]["total_unread"]}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                  );
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(DoctorScreen());
        },
        child: const Icon(
          Icons.search,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.message),
    );
  }
}
