import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medkit_app/components/custom_app_bar.dart';
import 'package:medkit_app/components/default_button.dart';
import 'package:medkit_app/controller/get_controll.dart';
import 'package:medkit_app/controller/get_prouct.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/models/Product.dart';
import 'package:medkit_app/screens/mcu/components/details/body.dart';
import 'package:medkit_app/screens/pesan/pesan_screen.dart';

class DetailMCUScreen extends StatelessWidget {
  static String routeName = "/mcudetail";

  @override
  Widget build(BuildContext context) {
    final cPesan = Get.put(CPemesanan());
    final ProductDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(rating: agrs.product.rate),
      ),
      body: Body(product: agrs.product),
      bottomNavigationBar: Container(
        color: kWhite,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultButton(
            text: "PESAN",
            press: () {
              //! change data
              cPesan.jamOP.value = agrs.product.jamOp;
              cPesan.id.value = agrs.product.id.toString();
              cPesan.product.value = agrs.product.product.toString();
              cPesan.price.value = agrs.product.price[0];
              cPesan.title.value = agrs.product.title.toString();
              cPesan.imgurl.value = agrs.product.photoUrl[0].toString();
              Get.to(() => PesanScreen());
            },
          ),
        ),
      ),
    );
  }
}

class ProductDetailsArguments {
  final ProductModels product;

  ProductDetailsArguments({required this.product});
}
