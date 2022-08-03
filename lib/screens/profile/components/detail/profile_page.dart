import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:medkit_app/components/form_error.dart';
import 'package:medkit_app/controller/auth_manage.dart';
import 'package:medkit_app/helper/keyboard.dart';
import 'package:medkit_app/item_constant.dart';
import 'package:medkit_app/screens/profile/components/profile_pic.dart';
import 'package:medkit_app/size_config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final authC = Get.put(AuthManage());

  @override
  Widget build(BuildContext context) {
    CollectionReference profile = firestore.collection('users');

    var id;
    String? name;
    String? address;
    String? phone;
    String? email;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: profile.where('email', isEqualTo: auth!.email).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var myData = snapshot.data!.docs;
              if (myData.isNotEmpty) {
                for (var i = 0; i < myData.length; i++) {
                  id = myData[i].id;
                  name = myData[i]['name'].toString();
                  phone = myData[i]['phoneNumber'].toString();
                  address = myData[i]['address'].toString();
                  email = myData[i]['email'].toString();
                }
                print('profile siap');
              }
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: getProportionateScreenWidth(30),
                      width: SizeConfig.screenWidth,
                    ),
                    const ProfilePic(),
                    SizedBox(
                      height: getProportionateScreenWidth(30),
                      width: SizeConfig.screenWidth,
                    ),
                    CardMenuProfile(
                        id: id,
                        trail: true,
                        value: name,
                        title: 'Name',
                        pesan: 'Harap masukkan nama anda sesuai data diri anda',
                        pathname: 'name',
                        icons: const Icon(Icons.account_circle_rounded)),
                    CardMenuProfile(
                        id: id,
                        trail: true,
                        value: phone,
                        pathname: 'phoneNumber',
                        title: 'Telepon',
                        icons: const Icon(Icons.call)),
                    CardMenuProfile(
                      id: id,
                      trail: true,
                      value: address,
                      pathname: 'address',
                      title: 'Alamat',
                      icons: const Icon(Icons.location_on_rounded),
                    ),
                    CardMenuProfile(
                      id: id,
                      trail: false,
                      value: email,
                      pathname: 'email',
                      title: 'E-mail',
                      icons: const Icon(Icons.mail),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class CardMenuProfile extends StatefulWidget {
  CardMenuProfile({
    Key? key,
    required this.id,
    required this.trail,
    this.pesan,
    required this.value,
    required this.title,
    required this.pathname,
    required this.icons,
  }) : super(key: key);
  String? pesan;
  final value, title, id, pathname;
  final bool trail;
  final Icon icons;

  @override
  State<CardMenuProfile> createState() => _CardMenuProfileState();
}

class _CardMenuProfileState extends State<CardMenuProfile> {
  final auth = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final authC = Get.put(AuthManage());
  bool isAdress = false;
  String? valuePath;

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          child: ListTile(
              leading: widget.icons,
              title: Text(
                widget.title.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.value == null
                        ? 'Data belum diisi'
                        : widget.value.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (widget.pesan != null)
                    Text(
                      widget.pesan.toString(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                ],
              ),
              trailing: widget.trail == true
                  ? IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: kPrimaryColor,
                      ),
                      onPressed: (widget.pathname == 'address')
                          ? () {
                              setState(() {
                                isAdress = !isAdress;
                                print(isAdress);
                              });
                            }
                          : () {
                              setState(() {
                                onChange();
                              });
                            },
                    )
                  : null),
        ),
        if (isAdress == true)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            width: SizeConfig.screenWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                    onPressed: () async {
                      bool serviceEnabled;
                      LocationPermission permission;

                      serviceEnabled =
                          await Geolocator.isLocationServiceEnabled();
                      if (!serviceEnabled) {
                        return Future.error('Location services are disabled');
                      }

                      permission = await Geolocator.checkPermission();
                      if (permission == LocationPermission.denied) {
                        permission = await Geolocator.requestPermission();
                        if (permission == LocationPermission.denied) {
                          return Future.error(
                              'Location permissions are denied');
                        }
                      }

                      if (permission == LocationPermission.deniedForever) {
                        return Future.error(
                            'Location permissions are permanently denied, we cannot request permissions.');
                      }

                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);

                      try {
                        List<Placemark> placemark =
                            await placemarkFromCoordinates(
                                position.latitude, position.longitude);
                        //! pilih file location
                        Placemark p = placemark[2];
                        String valueplace = p.street.toString() +
                            ', ' +
                            p.locality.toString() +
                            ', ' +
                            p.subLocality.toString() +
                            ', ' +
                            p.subAdministrativeArea.toString();
                        setState(() {
                          authC.updateProfile(
                              widget.id.toString(), 'address', valueplace);
                        });
                      } catch (e) {
                        print(e);
                      }

                      setState(() {
                        isAdress = !isAdress;
                      });
                    },
                    child: const Text('Isi Otomatis')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                    onPressed: () {
                      setState(() {
                        onChange();
                      });
                      isAdress = !isAdress;
                    },
                    child: const Text('Isi Lokasi')),
              ],
            ),
          )
      ],
    );
  }

  void onChange() {
    Get.defaultDialog(
        title: widget.title,
        content: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  keyboardType: widget.pathname == 'phoneNumber'
                      ? TextInputType.number
                      : widget.pathname == 'name'
                          ? TextInputType.name
                          : TextInputType.text,
                  inputFormatters: (widget.pathname == 'phoneNumber')
                      ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(13)
                        ]
                      : [],
                  initialValue: widget.value,
                  onSaved: (newValue) => valuePath = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty) {}
                    return;
                  },
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                  }),
                  decoration: const InputDecoration(
                    border: null,
                    hintText: 'data tidak boleh kosong',
                  ),
                ),
                const SizedBox(
                  height: 5,
                )
              ]),
            ),
            FormError(errors: errors),
          ],
        ),
        textCancel: 'Batal',
        onCancel: () {},
        buttonColor: kPrimaryColor,
        confirmTextColor: kWhite,
        cancelTextColor: kPrimaryColor,
        textConfirm: 'Selesai',
        onConfirm: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            KeyboardUtil.hideKeyboard(context);
            authC.updateProfile(widget.id.toString(),
                widget.pathname.toString(), valuePath.toString());
            Get.back();
          }
        });
  }
}

class GetIzin {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
