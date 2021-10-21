import 'package:flutter/services.dart';

class Constant {
  static const INTERNET_ALERT_MSG = "Internet not available, Please check your network connection!";
}

const PRICE_TEXT_LENGTH = 8;
TextInputType priceKeyboardType = TextInputType.phone;
List<TextInputFormatter> priceInputFormatter = [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)$'))];
