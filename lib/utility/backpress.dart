import 'package:flutter/material.dart';

class BackPress {
  static onBackPress(BuildContext context) {
    Navigator.pop(context);
  }

  static onStopBackPress() {
    // Fluttertoast.showToast(msg: "Back Again For Exit")
  }
}
