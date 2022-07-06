import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medkit_app/components/coustom_bottom_nav_bar.dart';
import 'package:medkit_app/controller/get_controll.dart';
import 'package:medkit_app/enums.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/screens/rawat/components/body.dart';

class RawatScreen extends StatelessWidget {
  static String routeName = "/rawat";
  @override
  Widget build(BuildContext context) {
    final cPesan = Get.put(CPemesanan());
    cPesan.onReload();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RS Citra Husada Jember',
        ),
      ),
      body: Body(),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
