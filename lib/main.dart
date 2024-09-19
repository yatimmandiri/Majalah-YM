import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:get/get.dart';
import 'package:magazine/core/fcm_firebase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id_ID').then((value) => {runApp(const MyApp())});

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAHv_SPtanizOTkz1ELE1d7esQuJQdmYTw',
        appId: '1:732509064583:android:b8dc04f0e0b267f0ad9722',
        messagingSenderId: '732509064583',
        projectId: 'majalah-yatim-mandiri-61d7b',
      ),
    );
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FcmFirebase().initNotif();
    await FcmFirebase().requestNotif();
    await FirebaseMessaging.instance.subscribeToTopic('Subscribed');
  } catch (e) {
    Fluttertoast.showToast(
      backgroundColor: Colors.red,
      msg: 'Error initializing Firebase',
    );
    // ignore: avoid_print
    print('Error initializing Firebase: $e');
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Warna background status bar
    statusBarIconBrightness:
        Brightness.light, // Warna ikon status bar menjadi putih
    statusBarBrightness: Brightness.light, // Untuk perangkat iOS
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MASA by Yatim Mandiri',
      transitionDuration: const Duration(milliseconds: 250),
      defaultTransition: Transition.rightToLeftWithFade,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
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
