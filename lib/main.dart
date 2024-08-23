import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:get/get.dart';
import 'package:magazine/core/fcm_firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await FcmFirebase().requestNotif();
  await FcmFirebase().initNotif();
  await FirebaseMessaging.instance.subscribeToTopic('Subscribed');

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Warna background status bar
    statusBarIconBrightness: Brightness.light, // Warna ikon status bar menjadi putih
    statusBarBrightness: Brightness.light, // Untuk perangkat iOS
  ));

  initializeDateFormatting('id_ID').then((value) => {runApp(const MyApp())});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Majalah Yatim Mandiri',
      transitionDuration: Duration(milliseconds: 250),
      defaultTransition: Transition.rightToLeftWithFade,
      theme: ThemeData(
          scaffoldBackgroundColor: BackgroundColor().main,
          appBarTheme: const AppBarTheme(
            backgroundColor: BaseColor.primary,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          )),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
