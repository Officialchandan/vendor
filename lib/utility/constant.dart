import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constant {
  static const INTERNET_ALERT_MSG = "Internet not available, Please check your network connection!";

  static const language = [Locale("en"), Locale("hi")];
  static const langList = [
    {"name": "English", "code": Locale("en")},
    {"name": "Hindi (हिंदी)", "code": Locale("hi")},
  ];
}

const PRICE_TEXT_LENGTH = 8;
TextInputType priceKeyboardType = TextInputType.phone;
List<TextInputFormatter> priceInputFormatter = [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)$'))];
