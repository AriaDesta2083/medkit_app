import 'package:flutter/material.dart';
import 'package:medkit_app/components/default_button.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/models/Product.dart';
import 'package:medkit_app/size_config.dart';

class DoctorScreen extends StatelessWidget {
  static String routname = '/doctor';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor'),
      ),
      body: Container(
        child: ListView(scrollDirection: Axis.horizontal, children: [
          ...List.generate(
            listDoctor.length,
            (index) {
              return Padding(
                padding:
                    EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
                child: CardDoctor(
                  product: listDoctor[index],
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}

class CardDoctor extends StatelessWidget {
  DoctorList product;
  CardDoctor({required this.product});
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
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(product.img.toString()),
                  fit: BoxFit.fitHeight),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Chat Dokter'),
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
