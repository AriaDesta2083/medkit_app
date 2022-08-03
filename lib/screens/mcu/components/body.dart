import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medkit_app/controller/get_prouct.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/models/Product.dart';
import 'package:medkit_app/screens/mcu/components/card_item.dart';
import 'package:medkit_app/size_config.dart';

class Body extends StatelessWidget {
  Body({
    Key? key,
  }) : super(key: key);
  final product = FirebaseFirestore.instance
      .collection('product')
      .where('active', isEqualTo: true)
      .where('product', isEqualTo: 'Medical Check Up')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: product,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Belum Ada Data '),
                );
              } else if (snapshot.hasData) {
                var myItems = snapshot.data!.docs;
                return Column(
                    children: myItems
                        .map(
                          (item) => CardItem(
                            product: ProductModels(
                                datecreate: item['datecreate'].toString(),
                                id: item.id.toString(),
                                title: item['title'],
                                product: item['product'],
                                deskripsi: item['deskripsi'],
                                price: item['price'],
                                categories: item['categories'],
                                photoUrl: item['photoUrl'],
                                jamOp: item['jamOp'],
                                active: item['active'],
                                rate: item['rate']),
                          ),
                        )
                        .toList());
              }
              return Text('data');
            }),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
