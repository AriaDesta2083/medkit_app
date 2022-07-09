import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medkit_app/controller/auth_controllerr.dart';
import 'package:medkit_app/controller/auth_services.dart';
import 'package:medkit_app/controller/get_controll.dart';
import 'package:medkit_app/controller/wrapper.dart';
import 'package:medkit_app/screens/profile/components/detail/profile_page.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final authC = Get.find<AuthController>();
  final authCC = Get.put(AuthControllerr());
  final login = Get.put(cLogin()).isLogin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 30),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () => Get.to(() => ProfilePage()),
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async {
                if (login.value.toString() == 'google') {
                  await authCC.logout();
                } else {
                  authC.signout();
                }
                Get.offAll(Wrapper());
              },
            ),
          ],
        ),
      ),
    );
  }
}
