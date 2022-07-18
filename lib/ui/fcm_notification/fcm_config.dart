import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ui/home/bottom_navigation_home.dart';
import 'package:vendor/ui/money_due_upi/upi_transfer/upi_transfer_screen.dart';
import 'package:vendor/ui/performance_tracker/report/select_report_types.dart';
import 'package:vendor/ui_without_inventory/home/bottom_navigation_bar.dart';
import 'package:vendor/ui_without_inventory/performancetracker/report/report_type_screen.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/upi_transfer/upi_transfer_history.dart';

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
    String grade = message.data['route']!;
    print("object$grade");
    switch (grade) {
      case "MoneyDueScreen":
        {
          Navigator.push(
              navigationService.navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (_) => BottomNavigationHome(
                        index: 2,
                      )));
          print("Excellent");
        }
        break;

      case "DueAmountScreen":
        {
          Navigator.push(
              navigationService.navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (_) => BottomNavigationHomeWithOutInventory(
                        index: 2,
                      )));
          print("Good");
        }
        break;

      case "UpiTransferHistory":
        {
          Navigator.push(
              navigationService.navigatorKey.currentContext!, MaterialPageRoute(builder: (_) => UpiTransferHistory()));
          print("Fair");
        }
        break;

      case "UpiTransferHistoryWithoutInventory":
        {
          Navigator.push(navigationService.navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => UpiTransferHistoryWithoutInventory()));
          print("Poor");
        }
        break;
      case "SelectReportTypeScreen":
        {
          Navigator.push(navigationService.navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => SelectReportTypeScreen()));
          print("Poor");
        }
        break;
      case "ReportTypeScreen":
        {
          Navigator.push(
              navigationService.navigatorKey.currentContext!, MaterialPageRoute(builder: (_) => ReportTypeScreen()));
          print("Poor");
        }
        break;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }
}
