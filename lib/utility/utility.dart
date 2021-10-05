import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vendor/utility/color.dart';

class Utility {
  static Future<bool> checkStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      var status = await Permission.storage.request();
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return true;
  }

  static Future<bool> checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      var status = await Permission.camera.request();
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return true;
  }

  static showToast(String msg) {
    Fluttertoast.showToast(msg: msg, textColor: Colors.white, backgroundColor: ColorPrimary, gravity: ToastGravity.BOTTOM);
  }

  static Future<String> findLocalPath() async {
    final directory = Platform.isAndroid ? await getTemporaryDirectory() : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
