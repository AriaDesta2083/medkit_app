import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    late List mylist = listPsikoIndividual;
    if (widget.list == 1) {
      mylist = listPsikoInstalasi;
    } else if (widget.list == 2) {
      mylist = listPsikoSekolah;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RS Citra Husada Jember',
        ),
      ),
      body: ListView(children: [
        ...List.generate(
          mylist.length,
          (index) {
            return Padding(
              padding:
                  EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
              child: CardItem(
                product: mylist[index],
              ),
            );
          },
        ),
      ]),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({Key? key, required this.product}) : super(key: key);
  final PsikoList product;
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
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                product.images,
                width: getProportionateScreenWidth(300),
                height: getProportionateScreenWidth(200),
                fit: BoxFit.cover,
              ),
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
                    product.title,
                    style: namaStyle.copyWith(color: kPrimaryColor),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    // CurrencyFormat.convertToIdr(product.price[0], 2).toString(),
                    'Jadwal : ' + product.time,
                    style: Theme.of(context).textTheme.bodyLarge,
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
                          children: [
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
