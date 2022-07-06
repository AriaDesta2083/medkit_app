import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medkit_app/components/coustom_bottom_nav_bar.dart';
import 'package:medkit_app/screens/psikotest/components/body.dart';

import '../../controller/get_controll.dart';
import '../../enums.dart';

class PsikotestScreen extends StatelessWidget {
  static String routeName = "/psikotest";
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
