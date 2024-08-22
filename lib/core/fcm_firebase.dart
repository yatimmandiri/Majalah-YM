import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handlerBgMessage(RemoteMessage message) async {
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Payload : ${message.data}');
}

class FcmFirebase {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotif() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();

    print('tokennya : ${fcmToken}');

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
