import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
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

  static String getFormatDate(DateTime dateTime) {
    String date = DateFormat('yyyy-MM-dd').format(dateTime).toString();
    debugPrint("date--> $date");
    return date;
  }

  static String getFormatDate1(DateTime dateTime) {
    String date = DateFormat('dd-MMM-yyyy - ').add_jm().format(dateTime).toString();
    debugPrint("date--> $date");
    return date;
  }
}

// class CurrencyData{
//
//   String code;
//   String? image;
//   double value;`
//   String? name;
//   bool? selected;
//   bool? favorite;
//
//   CurrencyData({required this.code,required this.value,this.name="",this.image="",this.selected=false,this.favorite=false});
//
//
//   factory CurrencyData.fromJson(String str) => CurrencyData.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory CurrencyData.fromMap(Map<String, dynamic> json) => CurrencyData(
//     code: json["code"]??"",
//     image: json["image"]??"",
//     value: json["value"] ??0.0,
//     name: json["name"] ??"",
//     selected: json["selected"]??false,
//     favorite: json["favorite"] ??false,
//   );
//
//   Map<String, dynamic> toMap() => {
//     "code": code,
//     "image": image,
//     "value": value,
//     "name": name,
//     "selected": selected,
//     "favorite": favorite,
//   };
//
// }
