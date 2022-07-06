import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medkit_app/components/form_error.dart';
import 'package:medkit_app/controller/auth_manage.dart';
import 'package:medkit_app/helper/keyboard.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/screens/profile/components/profile_pic.dart';
import 'package:medkit_app/size_config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final authC = Get.put(AuthManage());

  @override
  Widget build(BuildContext context) {
    CollectionReference profile = firestore.collection('profile');

    var id;
    String? name;
    String? addres;
    String? phone;
    String? email;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: profile.where('id', isEqualTo: auth!.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var myData = snapshot.data!.docs;
              if (myData.isNotEmpty) {
                for (var i = 0; i < myData.length; i++) {
                  id = myData[i].id;
                  name = myData[i]['name'];
                  phone = myData[i]['phone'];
                  addres = myData[i]['addres'];
                  email = myData[i]['email'];
                }
                print('profile siap');
              } else if (myData.isEmpty) {
                name = auth!.displayName;
                phone = auth!.phoneNumber;
                addres = null;
                email = auth!.email;

                profile.add({
                  'id': auth!.uid,
                  'name': name,
                  'phone': phone,
                  'addres': addres,
                  'email': email,
                });
                print('profile belum siap');
              }
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: getProportionateScreenWidth(30),
                      width: SizeConfig.screenWidth,
                    ),
                    ProfilePic(),
                    SizedBox(
                      height: getProportionateScreenWidth(30),
                      width: SizeConfig.screenWidth,
                    ),
                    CardMenuProfile(
                        id: id,
                        trail: true,
                        value: name,
                        title: 'Name',
                        pesan: 'Harap masukkan nama anda sesuai data diri anda',
                        pathname: 'name',
                        icons: Icon(Icons.account_circle_rounded)),
                    CardMenuProfile(
                        id: id,
                        trail: true,
                        value: phone,
                        pathname: 'phone',
                        title: 'Telepon',
                        icons: Icon(Icons.call)),
                    CardMenuProfile(
                      id: id,
                      trail: true,
                      value: addres,
                      pathname: 'addres',
                      title: 'Alamat',
                      icons: Icon(Icons.location_on_rounded),
                    ),
                    CardMenuProfile(
                      id: id,
                      trail: false,
                      value: email,
                      pathname: 'email',
                      title: 'E-mail',
                      icons: Icon(Icons.mail),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class CardMenuProfile extends StatefulWidget {
  CardMenuProfile({
    Key? key,
    required this.id,
    required this.trail,
    this.pesan,
    required this.value,
    required this.title,
    required this.pathname,
    required this.icons,
  }) : super(key: key);
  String? pesan;
  final value, title, id, pathname;
  final bool trail;
  final Icon icons;

  @override
  State<CardMenuProfile> createState() => _CardMenuProfileState();
}

class _CardMenuProfileState extends State<CardMenuProfile> {
  final auth = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final authC = Get.put(AuthManage());
  String? valuePath;

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          child: ListTile(
              leading: widget.icons,
              title: Text(
                widget.title.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.value == null
                        ? 'Data belum diisi'
                        : widget.value.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (widget.pesan != null)
                    Text(
                      widget.pesan.toString(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                ],
              ),
              trailing: widget.trail == true
                  ? IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        Get.defaultDialog(
                            title: widget.title,
                            content: Column(
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Column(children: [
                                    TextFormField(
                                      keyboardType: widget.pathname == 'phone'
                                          ? TextInputType.number
                                          : widget.pathname == 'name'
                                              ? TextInputType.name
                                              : TextInputType.text,
                                      initialValue: widget.value,
                                      onSaved: (newValue) =>
                                          valuePath = newValue,
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          removeError(error: kUpdateData);
                                        }
                                        return;
                                      },
                                      validator: ((value) {
                                        if (value!.isEmpty) {
                                          addError(error: kUpdateData);
                                          setState(() {});
                                          return "";
                                        }
                                      }),
                                      decoration: InputDecoration(
                                        border: null,
                                        hintText: 'data tidak boleh kosong',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ]),
                                ),
                                FormError(errors: errors),
                              ],
                            ),
                            textCancel: 'Batal',
                            onCancel: () {},
                            buttonColor: kPrimaryColor,
                            confirmTextColor: kWhite,
                            cancelTextColor: kPrimaryColor,
                            textConfirm: 'Selesai',
                            onConfirm: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                KeyboardUtil.hideKeyboard(context);
                                authC.updateProfile(
                                    widget.id.toString(),
                                    widget.pathname.toString(),
                                    valuePath.toString());
                                Get.back();
                              }
                            });
                      },
                    )
                  : null),
        ),
      ],
    );
  }
}
