import 'package:flutter/material.dart';
import 'package:medkit_app/components/default_button.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/models/Product.dart';
import 'package:medkit_app/rupiah.dart';
import 'package:medkit_app/size_config.dart';

class Body extends StatelessWidget {
  final MCUList product;

  const Body({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: product,
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

  final MCUList product;

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
          width: double.infinity,
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
        SizedBox(height: getProportionateScreenWidth(10)),
        Container(
          color: kPrimaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.product.title.toString(),
                style: namaStyle,
              )
            ],
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

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final MCUList product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            CurrencyFormat.convertToIdr(product.price, 2),
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            'Layanan pada ${product.title} :',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            product.description,
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
