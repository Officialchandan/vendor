import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constant {
  static final INTERNET_ALERT_MSG =
      "please_check_your_internet_connection_key".tr();

  static const language = [Locale("en"), Locale("hi")];
  static const langList = [
    {"name": "English", "code": Locale("en")},
    {"name": "Hindi (हिंदी)", "code": Locale("hi")},
  ];
}

const PRICE_TEXT_LENGTH = 8;
TextInputType priceKeyboardType =
    TextInputType.numberWithOptions(decimal: true, signed: false);
List<TextInputFormatter> priceInputFormatter = [
  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,5}'))
];
List<TextInputFormatter> positiveintger = [
  FilteringTextInputFormatter.allow(RegExp(r'(^[0-9]*$)'))
];

String capitalizeAllWord(String value) {
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " ") {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
    }
  }
  return result;
}
