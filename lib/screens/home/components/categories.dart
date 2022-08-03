import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medkit_app/controller/auth_controllerr.dart';
import 'package:medkit_app/controller/auth_services.dart';
import 'package:medkit_app/controller/get_controll.dart';
import 'package:medkit_app/screens/doctor/doctor_screen.dart';
import 'package:medkit_app/screens/icu/icu_screen.dart';
import 'package:medkit_app/screens/mcu/mcu_screen.dart';
import 'package:medkit_app/screens/psikotest/psikotest_screen.dart';
import 'package:medkit_app/screens/rawat/rawat_screen.dart';

import '../../../size_config.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLogin = Get.put(cLogin());
    List<Map<String, dynamic>> categories = [
      {
        "icon": "assets/icons/ic_doctor.svg",
        "text": "Doctor",
        "press": DoctorScreen()
      },
      {
        "icon": "assets/icons/ic_dnatest.svg",
        "text": "Psiko Test",
        "press": PsikotestScreen()
      },
      {
        "icon": "assets/icons/ic_labtest.svg",
        "text": "MCU",
        "press": MCUScreen()
      },
      {
        "icon": "assets/icons/ic_dropper.svg",
        "text": "ICU",
        'press': ICUScreen()
      },
      {"icon": "assets/icons/ic_vaksin.svg", "text": "Vaksin"},
      {
        "icon": "assets/icons/ic_pill.svg",
        "text": "Rawat",
        "press": RawatScreen()
      },
    ];
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: Wrap(
        spacing: 15,
        runSpacing: 4,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {
              print(isLogin.isLogin.value);
              Get.to(categories[index]["press"]);
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String? icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            Container(
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
                    offset: Offset(0, 3), // changes position of shadow
                  )
                ],
              ),
              child: SvgPicture.asset(
                icon!,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(text!, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
