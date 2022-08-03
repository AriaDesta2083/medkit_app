import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medkit_app/controller/auth_controllerr.dart';
import 'package:medkit_app/controller/get_controll.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/size_config.dart';

import '../../controller/auth_services.dart';

class DoctorScreen extends StatelessWidget {
  static String routname = '/doctor';
  final Stream<QuerySnapshot> _doctor = FirebaseFirestore.instance
      .collection('users')
      .where('status', isNotEqualTo: 'customer')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor'),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: _doctor,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text('Belum ada Docket yang terdaftar'));
              } else {
                var myDoctor = snapshot.data!.docs;
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: myDoctor
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: CardDoctor(
                              userdata: UserModel(
                                  uid: item['uid'],
                                  name: item['name'],
                                  keyName: item['keyName'],
                                  email: item['email'],
                                  creationTime: item['creationTime'],
                                  lastSignInTime: item['lastSignInTime'],
                                  photoUrl: item['photoUrl'],
                                  phoneNumber: item['phoneNumber'],
                                  address: item['address'],
                                  status: item['status'],
                                  updatedTime: item['updatedTime'])),
                        ),
                      )
                      .toList(),
                );
              }
            }),
        // child: ListView(scrollDirection: Axis.horizontal, children: [
        //   ...List.generate(
        //     listDoctor.length,
        //     (index) {
        //       return Padding(
        //         padding:
        //             EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
        //         child: CardDoctor(
        //           product: listDoctor[index],
        //         ),
        //       );
        //     },
        //   ),
        // ]),
      ),
    );
  }
}

class CardDoctor extends StatelessWidget {
  final authC = Get.put(AuthController());
  final authCC = Get.put(AuthControllerr());
  final login = Get.put(cLogin()).isLogin;
  UserModel userdata;
  CardDoctor({required this.userdata});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: SizeConfig.screenHeight - 300,
            width: SizeConfig.screenWidth - 40,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: kPrimaryGraColor,
              // image: DecorationImage(
              //   image: NetworkImage(product.img.toString()),
              //   fit: BoxFit.fitHeight,
              // ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                userdata.photoUrl.toString(),
                fit: BoxFit.fitHeight,
                loadingBuilder: loadingCircular,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              if (login.value == 'google') {
                authCC.firstInitialized();
                authCC.addNewConnection(userdata.email.toString());
              } else if (login.value == 'email') {
                // authCC.addNewConnection('aria.destaaaaa@gmail.com');
                authC.firstInitialized();
                authC.addNewConnection(userdata.email.toString());
              }
            },
            child: const Text('Chat Dokter'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              fixedSize: Size(SizeConfig.screenWidth - 40, 60),
              primary: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.keyName,
    required this.email,
    required this.creationTime,
    required this.lastSignInTime,
    required this.photoUrl,
    required this.phoneNumber,
    required this.address,
    required this.status,
    required this.updatedTime,
  });

  String uid;
  String name;
  String keyName;
  String email;
  String creationTime;
  String lastSignInTime;
  String photoUrl;
  String phoneNumber;
  String address;
  String status;
  String updatedTime;
}
