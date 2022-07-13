import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ui/money_due_upi/money_due_screen.dart';

import '../../main.dart';

class FcmConfig {
  static NotificationSettings? settings;
  static String fcmToken = "";

  static requestPermission() async {
    settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings!.authorizationStatus}');
  }

  static configNotification() async {
    await FcmConfig.requestPermission();
    print("configNotification--->");
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {});
  }

  static Future<void> getInitialMessage(RemoteMessage message) async {
    print("getInitialMessage--->${message.toMap()}");
    if (message.data['route'] == "MoneyDueScreen") {
      Navigator.push(
          navigationService.navigatorKey.currentContext!, MaterialPageRoute(builder: (_) => MoneyDueScreen(true)));
    } else if (message.data['route'] == "MoneyDueScreen") {
      Navigator.push(
          navigationService.navigatorKey.currentContext!, MaterialPageRoute(builder: (_) => MoneyDueScreen(true)));
    } else {}
  }
}
