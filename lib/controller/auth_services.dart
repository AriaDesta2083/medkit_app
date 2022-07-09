import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medkit_app/controller/get_controll.dart';
import 'package:medkit_app/controller/wrapper.dart';
import 'package:medkit_app/data/users_model.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/screens/sign_in/sign_in_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get streamAuthStatus => auth.authStateChanges();
  final login = Get.put(cLogin()).isLogin;
  UserCredential? userCredential;
  var user = UsersModel().obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User? _currentUser = FirebaseAuth.instance.currentUser;
  var isAuth = false.obs;

  Future<void> firstInitialized() async {
    login.value = 'email';
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });
  }

  Future<bool> autoLogin() async {
    login.value = 'email';

    // kita akan mengubah isAuth => true => autoLogin
    print(_currentUser);
    print(user);
    print(userCredential);

    // masukan data ke firebase...
    CollectionReference users = firestore.collection('users');

    await users.doc(_currentUser!.email).update({
      "lastSignInTime":
          _currentUser!.metadata.lastSignInTime!.toIso8601String(),
    });

    final currUser = await users.doc(_currentUser!.email).get();
    final currUserData = currUser.data() as Map<String, dynamic>;
    print('object');
    print(currUserData);

    user(UsersModel.fromJson(currUserData));

    user.refresh();

    final listChats =
        await users.doc(_currentUser!.email).collection("chats").get();

    if (listChats.docs.length != 0) {
      List<ChatUser> dataListChats = [];
      listChats.docs.forEach((element) {
        var dataDocChat = element.data();
        var dataDocChatId = element.id;
        dataListChats.add(ChatUser(
          chatId: dataDocChatId,
          connection: dataDocChat["connection"],
          lastTime: dataDocChat["lastTime"],
          total_unread: dataDocChat["total_unread"],
        ));
      });

      user.update((user) {
        user!.chats = dataListChats;
      });
    } else {
      user.update((user) {
        user!.chats = [];
      });
    }

    user.refresh();

    return true;
  }

  void signin(String email, String pw) async {
    login.value == 'email';

    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: pw)
          .then((value) => userCredential = value);

      _currentUser = auth.currentUser;
      print("USER CREDENTIAL");
      print(userCredential);

      if (userCredential!.user!.emailVerified) {
        CollectionReference users = firestore.collection('users');

        final checkuser = await users.doc(_currentUser!.email).get();

        if (checkuser.data() == null) {
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": "noimage",
            "status": "",
            "phoneNumber": "",
            "address": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
          });

          await users.doc(_currentUser!.email).collection("chats");
        } else {
          await users.doc(_currentUser!.email).update({
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }
        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        user.refresh();

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });

          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        user.refresh();

        isAuth.value = true;
        Get.offAllNamed(Wrapper.routeName);
      } else {
        Get.defaultDialog(
            buttonColor: kPrimaryColor,
            confirmTextColor: kWhite,
            title: 'Verification E-mail',
            middleText:
                "Kamu perlu menlakukan email verifikasi. Silahkan cek $email anda dan lakukan verifikasi.",
            onConfirm: () {
              Get.back();
            });
        print('test');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.defaultDialog(
            title: 'Login Gagal', middleText: 'User Tidak Ditemukan');
      } else if (e.code == 'wrong-password') {
        Get.defaultDialog(title: 'Login Gagal', middleText: 'Password Salah');
      }
    }
  }

  void signup(String name, String email, String kpw) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: kpw);

      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.sendEmailVerification();

      Get.defaultDialog(
          buttonColor: kPrimaryColor,
          confirmTextColor: kWhite,
          title: 'Registrasi Berhasil',
          middleText:
              "Kami telah mengirimkan email verifikasi. Silahkan cek $email anda dan lakukan verifikasi.",
          onConfirm: () {
            Get.off(SignInScreen());
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.defaultDialog(
            title: 'Register Gagal', middleText: 'Password Terlalu Lemah');
      } else if (e.code == 'email-already-in-use') {
        Get.defaultDialog(
            title: 'Register Gagal', middleText: 'Email Telah Digunakan');
      }
    }
  }

  void signout() async {
    await auth.signOut();
    await FirebaseAuth.instance.signOut();
  }

  void addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    var chat_id;
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final docChats =
        await users.doc(_currentUser!.email).collection("chats").get();

    if (docChats.docs.length != 0) {
      // user sudah pernah chat dengan siapapun
      final checkConnection = await users
          .doc(_currentUser!.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.length != 0) {
        // sudah pernah buat koneksi dengan => friendEmail
        flagNewConnection = false;

        //chat_id from chats collection
        chat_id = checkConnection.docs[0].id;
      } else {
        // blm pernah buat koneksi dengan => friendEmail
        // buat koneksi ....
        flagNewConnection = true;
      }
    } else {
      // blm pernah chat dengan siapapun
      // buat koneksi ....
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      // cek dari chats collection => connections => mereka berdua...
      final chatsDocs = await chats.where(
        "connections",
        whereIn: [
          [
            _currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser!.email,
          ],
        ],
      ).get();

      if (chatsDocs.docs.length != 0) {
        // terdapat data chats (sudah ada koneksi antara mereka berdua)
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(chatDataId)
            .set({
          "connection": friendEmail,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0,
        });

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = List.empty(growable: true);
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chat_id = chatDataId;

        user.refresh();
      } else {
        // buat baru , mereka berdua benar2 belum ada koneksi
        final newChatDoc = await chats.add({
          "connections": [
            _currentUser!.email,
            friendEmail,
          ],
        });

        await chats.doc(newChatDoc.id).collection("chat");

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(newChatDoc.id)
            .set({
          "connection": friendEmail,
          "lastTime": date,
          "total_unread": 0,
        });

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = List<ChatUser>.empty(growable: true);
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chat_id = newChatDoc.id;

        user.refresh();
      }
    }

    print(chat_id);

    final updateStatusChat = await chats
        .doc(chat_id)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("penerima", isEqualTo: _currentUser!.email)
        .get();

    updateStatusChat.docs.forEach((element) async {
      await chats
          .doc(chat_id)
          .collection("chat")
          .doc(element.id)
          .update({"isRead": true});
    });

    await users
        .doc(_currentUser!.email)
        .collection("chats")
        .doc(chat_id)
        .update({"total_unread": 0});

    Get.toNamed(
      '/chatroomview',
      arguments: {
        "chat_id": "$chat_id",
        "friendEmail": friendEmail,
      },
    );
  }
}
