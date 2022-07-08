import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:medkit_app/routes.dart';
import 'package:medkit_app/routes/app_pages.dart';
import 'package:medkit_app/screens/splash/splash_screen.dart';
import 'package:medkit_app/theme.dart';

//! Github

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', 'US'), // American English
        Locale('id', 'ID'), // Indonesia
        // ...
      ],
      title: 'Medikal Kit App',
      theme: theme(),
      // home: HomeScreen(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
      // getPages: AppPages.routes,
    );
  }
}




// class MyApp extends StatelessWidget {
//   final authC = Get.put(AuthControl(), permanent: true);
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//         stream: authC.streamAuthStatus,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.active) {
//             return GetMaterialApp(
//               debugShowCheckedModeBanner: false,
//               title: 'Medikal Kit App',
//               theme: theme(),
//               // home: HomeScreen(),
//               initialRoute: snapshot.data == null
//                   ? SplashScreen.routeName
//                   : HomeScreen.routeName,
//               routes: routes,
//             );
//           }
//           return SplashScreen();
//         });
//   }
// }

