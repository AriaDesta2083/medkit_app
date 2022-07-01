import 'package:flutter/material.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/models/Product.dart';
import 'package:medkit_app/screens/mcu/components/card_item.dart';
import 'package:medkit_app/size_config.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Text(
              '''Medical checkup mencakup serangkaian wawancara dan pemeriksaan kesehatan. Medical checkup bertujuan untuk mendeteksi secara dini bila ada masalah kesehatan tersembunyi yang belum menunjukkan gejala dan juga menentukan tingkat kebugaran dan kesehatan umum.
Rumah Sakit Citra Husada menyediakan paket MCU sesuai kebutuhan pasien : ''',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          ...List.generate(
            listMCU.length,
            (index) {
              return Padding(
                padding:
                    EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
                child: CardItem(product: listMCU[index]),
              ); // here by default width and height is 0
            },
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
