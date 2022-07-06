import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medkit_app/components/default_button.dart';
import 'package:medkit_app/controller/get_controll.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/screens/icu/components/body.dart';
import 'package:medkit_app/screens/pesan/pesan_screen.dart';

class ICUScreen extends StatelessWidget {
  static String routeName = "/icu";

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
        bottomNavigationBar: Container(
          color: kWhite,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultButton(
              text: "PESAN",
              press: () {
                //! change data
                Get.to(() => PesanScreen());
              },
            ),
          ),
        ));
  }
}
