import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medkit_app/controller/get_prouct.dart';
import 'package:medkit_app/controller/storage_services.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/models/Product.dart';
import 'package:medkit_app/rupiah.dart';
import 'package:medkit_app/screens/psikotest/components/details/detail_page.dart';
import 'package:medkit_app/size_config.dart';

class PsikoListScreen extends StatefulWidget {
  static String routeName = 'psikolist';
  final int list;
  const PsikoListScreen({Key? key, required this.list}) : super(key: key);

  @override
  State<PsikoListScreen> createState() => _PsikoListScreenState();
}

class _PsikoListScreenState extends State<PsikoListScreen> {
  String? psikologi = "Psikologis Individu";
  @override
  Widget build(BuildContext context) {
    if (widget.list == 1) {
      psikologi = "Psikologis Instansi";
    } else if (widget.list == 2) {
      psikologi = "Psikologis Sekolah";
    } else if (widget.list == 3) {
      psikologi = "Psikologis Individu";
    }
    // final Stream<QuerySnapshot> product = FirebaseFirestore.instance
    //     .collection('product')
    //     .where('title', isEqualTo: cProduct.product.value)
    //     .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RS Citra Husada Jember',
        ),
      ),
      body: ListView(children: [
        SizedBox(
          height: 10,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('product')
                .where('product', isEqualTo: psikologi)
                .where('active', isEqualTo: true)
                .snapshots(),
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
              } else {
                var myItems = snapshot.data!.docs;
                return Column(
                    children: myItems
                        .map((item) => CardItem(
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
                            ))
                        .toList());
              }
            }),
      ]),
    );
  }
}

class CardItem extends StatelessWidget {
  CardItem({Key? key, required this.product}) : super(key: key);
  final ProductModels product;
  final StorageProduct storage = StorageProduct();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(getProportionateScreenWidth(15)),
      elevation: 1,
      shadowColor: kPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: getProportionateScreenWidth(305),
              height: getProportionateScreenWidth(205),
              child: StreamBuilder(
                  stream: Stream.fromFuture(
                      storage.downloadURL(product.photoUrl[0])),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: kOrange,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          snapshot.data!,
                          width: getProportionateScreenWidth(300),
                          height: getProportionateScreenWidth(200),
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                    return const Center(
                      child: Text('Something Wrong'),
                    );
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: getProportionateScreenWidth(310),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title.toString(),
                    style: namaStyle.copyWith(color: kPrimaryColor),
                  ),
                  const SizedBox(width: 5),
                  Row(
                    children: [
                      Text(
                        product.rate.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset("assets/icons/Star Icon.svg"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () =>
                          //!PUSHH
                          Navigator.pushNamed(
                        context,
                        DetailPsikoScreen.routeName,
                        arguments: ProductDetailsArguments(product: product),
                      ),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                        width: getProportionateScreenWidth(80),
                        height: getProportionateScreenWidth(35),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'Detail',
                              style: TextStyle(fontSize: 15, color: kWhite),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: kWhite,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
