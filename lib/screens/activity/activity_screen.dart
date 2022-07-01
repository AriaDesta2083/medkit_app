import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medkit_app/components/coustom_bottom_nav_bar.dart';
import 'package:medkit_app/enums.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/models/Product.dart';
import 'package:medkit_app/size_config.dart';

class ActivityScreen extends StatefulWidget {
  static String routeName = "/activity";

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final auth = FirebaseAuth.instance.currentUser;
  CollectionReference pesanan =
      FirebaseFirestore.instance.collection('pesanan');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RS Citra Husada Jember',
        ),
      ),
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: pesanan.where('uid', isEqualTo: auth!.uid).snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  var myItems = snapshot.data!.docs;
                  return ListView(
                      children: myItems
                          .map(
                            (item) => CardItemPesanan(
                              PesananItem(
                                  id: item['id'],
                                  price: item['price'],
                                  title: item['title'],
                                  categories: item['categories'],
                                  imgurl: item['imgurl'],
                                  status: item['status'],
                                  payment: item['payment'],
                                  datepick: item['datepick'],
                                  datecreate: item['datecreate'],
                                  uid: item['uid'],
                                  name: item['name'],
                                  kode: item['kode']),
                            ),
                          )
                          .toList());
                } else {
                  return Text(
                    'Belum ada Pesanan ',
                  );
                }
              })),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.activity),
    );
  }
}

class CardItemPesanan extends StatelessWidget {
  final PesananItem product;
  CardItemPesanan(this.product);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(getProportionateScreenWidth(15)),
      elevation: 1,
      shadowColor: kPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: Container(
          width: SizeConfig.screenWidth - 100,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      product.imgurl.toString(),
                      width: getProportionateScreenWidth(120),
                      height: getProportionateScreenWidth(120),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      product.title,
                      style: namaStyle.copyWith(
                          color: kPrimaryColor, fontSize: 15),
                      softWrap: true,
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.account_circle_sharp,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    product.name.toString(),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    product.datepick.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
