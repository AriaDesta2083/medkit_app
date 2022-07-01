import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medkit_app/components/default_button.dart';
import 'package:medkit_app/controller/get_controll.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/models/Product.dart';
import 'package:medkit_app/rupiah.dart';
import 'package:medkit_app/screens/pesan/pesan_screen.dart';
import 'package:medkit_app/size_config.dart';

class Body extends StatefulWidget {
  final PsikoList product;

  const Body({Key? key, required this.product}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: widget.product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final PsikoList product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: SizeConfig.screenWidth,
          height: getProportionateScreenHeight(275),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.product.id.toString(),
              child: Image.asset(
                widget.product.images,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(5)),
        Container(
          width: SizeConfig.screenWidth,
          color: kPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.product.title.toString(),
              style: namaStyle,
            ),
          ),
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(2),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: shadowBOX,
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            widget.product.images[index],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final PsikoList product;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  int? myselected = 0;
  @override
  Widget build(BuildContext context) {
    final cPesan = Get.find<CPemesanan>();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            CurrencyFormat.convertToIdr(widget.product.price[myselected!], 2),
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Jadwal : ' + widget.product.time,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(
            height: 10,
          ),
          if (widget.product.categories.length > 1)
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Pelayanan : ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ListTile(
                    leading: Radio(
                        activeColor: kPrimaryColor,
                        value: 0,
                        groupValue: myselected,
                        onChanged: (value) {
                          setState(() {
                            myselected = 0;
                            cPesan.price.value =
                                widget.product.price[0].toInt();
                            cPesan.categories.value =
                                widget.product.categories[0].toString();
                            print(cPesan.categories.value);
                          });
                        }),
                    title: Text(
                      widget.product.categories[0].toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    leading: Radio(
                        activeColor: kPrimaryColor,
                        value: 1,
                        groupValue: myselected,
                        onChanged: (value) {
                          setState(() {
                            myselected = 1;
                            cPesan.price.value =
                                widget.product.price[1].toInt();
                            cPesan.categories.value =
                                widget.product.categories[1].toString();
                          });
                        }),
                    title: Text(
                      widget.product.categories[1].toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          Text(
            widget.product.description,
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenWidth(10)),
      padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        boxShadow: shadowBOXtop,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }
}
