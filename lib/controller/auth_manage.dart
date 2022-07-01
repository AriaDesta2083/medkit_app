import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthManage extends GetxController {
  CollectionReference profile =
      FirebaseFirestore.instance.collection('profile');
  CollectionReference imgprofile =
      FirebaseFirestore.instance.collection('imgprofile');

  Future<void> updateProfile(id, namepath, valuepath) async {
    await profile
        .doc(id)
        .update({namepath: valuepath})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateImgProfile(id, namepath, valuepath) async {
    await imgprofile
        .doc(id)
        .update({namepath: valuepath})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
