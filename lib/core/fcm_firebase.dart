import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<void> handlerBgMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
  print('Message data: ${message.data}');
}

class FcmFirebase {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotif() async {
    await _firebaseMessaging.deleteToken();

    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();

    if (kDebugMode) {
      print('tokennya : $fcmToken');
    }

    FirebaseMessaging.onBackgroundMessage(handlerBgMessage);
  }

  Future<void> requestNotif() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Notif : ${settings.authorizationStatus}');
  }
}
