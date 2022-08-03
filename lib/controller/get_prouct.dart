import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductModels {
  String? id;
  final String title, product, deskripsi, datecreate;
  late List<dynamic> categories, price, photoUrl, jamOp = [];
  late bool active = true;
  final double rate;

  ProductModels(
      {required this.id,
      required this.title,
      required this.product,
      required this.deskripsi,
      required this.price,
      required this.categories,
      required this.photoUrl,
      required this.datecreate,
      required this.jamOp,
      required this.active,
      required this.rate});
}
// class CProduct extends GetxController {
//   CollectionReference mproduct =
//       FirebaseFirestore.instance.collection('product');

//   var title = 'default'.obs;
//   var product = 'default'.obs;
//   var deskripsi = 'default'.obs;
//   var price = [].obs;
//   var categories = [].obs;
//   var photoUrl = [].obs;
//   var jamOp = [].obs;
//   var active = false.obs;
//   var rate = 5.0.obs;

//   void onReload() {
//     title.value = 'default';
//     product.value = 'default';
//     deskripsi.value = 'default';
//     price.value = [];
//     categories.value = [];
//     photoUrl.value = [];
//     jamOp.value = [];
//     active.value = false;
//     rate.value = 5.0;
//   }

//   void onRefresh() {
//     title.value = 'default';
//     deskripsi.value = 'default';
//     price.value = [];
//     categories.value = [];
//     photoUrl.value = [];
//     jamOp.value = [];
//     active.value = false;
//     rate.value = 5.0;
//   }

//   Future<void> onProduct() async {
//     mproduct
//         .add({
//           'title': title.value,
//           'product': product.value,
//           'price': price,
//           'categories': categories,
//           'deskripsi': deskripsi.value,
//           'jamOp': jamOp,
//           'photoUrl': photoUrl,
//           'active': active.value,
//           'rate': rate.value
//         })
//         .then((value) => print('Product add'))
//         .catchError((error) => print('Failed to add : $error'));
//   }

//   Future<void> updateProduct(id, namepath, valuepath) async {
//     await mproduct
//         .doc(id)
//         .update({namepath: valuepath})
//         .then((value) => print("Product updated"))
//         .catchError((error) => print("Failed to updated: $error"));
//   }

//   Future<bool> cekProduct(String myTitle) async {
//     final myProduct = await mproduct.where('title', isEqualTo: myTitle).get();

//     if (myProduct.docs.isNotEmpty) {
//       print('ada data');
//       return true;
//     } else {
//       print('tidak ada data');
//       return false;
//     }
//   }
// }

// class MProduct {
//   String? title, product, deskripsi;
//   List? price, categories, photoUrl, jamOP;
//   final bool active;
//   MProduct(
//       {this.title,
//       this.product,
//       this.deskripsi,
//       required this.active,
//       this.categories,
//       this.photoUrl,
//       this.jamOP,
//       this.price});
// }
