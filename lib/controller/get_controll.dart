import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:get/get.dart';

class CPayment extends GetxController {
  var payment = 'Pilih Metode Pembayaran'.obs;
  void changePayment(String newPayment) {
    payment.value = newPayment;
    print(payment.value.toString());
  }
}

class CPemesanan extends GetxController {
  final auth = FirebaseAuth.instance.currentUser;
  CollectionReference pesanan =
      FirebaseFirestore.instance.collection('pesanan');

  var id = 'default'.obs;
  var product = 'default'.obs;
  var title = 'default'.obs;
  var price = 0.obs;
  var categories = 'default'.obs;
  var imgurl = 'default'.obs;
  var status = 'default'.obs;
  var payment = 'default'.obs;
  var datepick = 'default'.obs;
  var uid = 'default'.obs;
  var name = 'default'.obs;
  var kode = 'default'.obs;
  var jamOP = [].obs;
  var timepick = 'Pilih Waktu Janji Medis'.obs;

  void onReload() {
    timepick.value = 'Pilih Waktu Janji Medis';
    id.value = 'default';
    product.value = 'default';
    title.value = 'default';
    price.value = 0;
    categories.value = 'default';
    imgurl.value = 'default';
    status.value = 'default';
    payment.value = 'default';
    datepick.value = 'default';
    uid.value = 'default';
    name.value = 'default';
    kode.value = 'default';
  }

  void onCekPesan() {
    kode.value = id.value.toString().randomItem() +
        product.value.toString().randomItem() +
        title.value.toString().randomItem() +
        price.value.toString().randomItem() +
        categories.value.toString().randomItem() +
        imgurl.value.toString()[1] +
        status.value.toString().randomItem() +
        payment.value.toString().randomItem() +
        // datepick.value.toString().substring(6).randomItem() +
        // datecreate.value.toString().substring(6).randomItem() +
        uid.value.toString().randomItem() +
        name.value.toString().randomItem();
    print('DATA UPDATE \n \n ' +
        id.value.toString() +
        '\n' +
        product.value.toString() +
        '\n' +
        title.value.toString() +
        '\n' +
        price.value.toString() +
        '\n' +
        categories.value.toString() +
        '\n' +
        imgurl.value.toString() +
        '\n' +
        status.value.toString() +
        '\n' +
        payment.value.toString() +
        '\n' +
        datepick.value.toString() +
        '\n' +
        // datecreate.value.toString() +
        // '\n' +
        uid.value.toString() +
        '\n' +
        name.value.toString() +
        '\n' +
        kode.value.toString().toUpperCase());
  }

  Future<bool> cekWaktuPEsanan(String title, date, time) async {
    final myPesan = await pesanan
        .where(
          'title',
          isEqualTo: title,
        )
        .where('datepick', isEqualTo: date)
        .where('timepick', isEqualTo: time)
        .get();

    if (myPesan.docs.isNotEmpty) {
      print('ada data');
      return true;
    } else {
      print('tidak ada data');
      return false;
    }
  }

  Future<void> onPemesanan() async {
    await pesanan
        .add({
          'id': id.toString(),
          'title': title.toString(),
          'product': product.value.toString(),
          'price': price.toInt(),
          'categories': categories.toString(),
          'imgurl': imgurl.toString(),
          'payment': payment.toString(),
          'status': status.toString(),
          'timepick': timepick.toString(),
          'datepick': datepick.toString(),
          'datecreate': Timestamp.now(),
          'uid': uid.toString(),
          'name': name.toString(),
          'kode': kode.toString().toUpperCase()
        })
        .then((value) => print('Pesanan updated'))
        .catchError((error) => print('Failed to add : $error'));
  }

  Future<void> updatePesanan(id, namepath, valuepath) async {
    await pesanan
        .doc(id)
        .update({namepath: valuepath})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to delete: $error"));
  }

  Future<void> deletePesanan(id, namepath, valuepath) async {
    await pesanan
        .doc(id)
        .delete()
        .then((value) => print("Pesanan del"))
        .catchError((error) => print("Failed to delete: $error"));
  }
}

class cKonsul extends GetxController {
  RxBool isBuy = false.obs;
  Rx<DateTime> datetime = DateTime.now().obs;

  void onBuy(DateTime time) {
    isBuy.value = true;
    datetime.value = time;
  }

  @override
  void onInit() {
    if (DateTime.now() == datetime.value) {
      isBuy.value = false;
    }
    super.onInit();
  }
}

class cLogin extends GetxController {
  var isLogin = 'default'.obs;
  void onsigninemail() {
    isLogin.value = 'email';
  }

  void onsigingoogle() {
    isLogin.value = 'google';
  }
}

class cBayar extends GetxController {
  var bayar = 'default'.obs;
}
