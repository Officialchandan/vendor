import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

class Validator {
  static RegExp emailRegex = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  static RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static RegExp doubleRegex = RegExp(r'^(?:0|[1-9][0-9]*)\.[0-9]+$');

  static RegExp name = RegExp(r'[a-zA-Z]');

  static String? emailValidator(String email) {
    if (email.isEmpty) {
      return null;
    }

    if (!emailRegex.hasMatch(email)) {
      return 'invalid_email_address_key'.tr();
    }
    return null;
  }

  static String? validateMobile(String value, BuildContext context) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      // return "please_enter_mobile_number_key".tr();
    } else if (value.length != 10) {
      return "mobile_number_must_10_digits_key".tr();
    } else if (!regExp.hasMatch(value)) {
      return "mobile_number_must_be_digits_key".tr();
    }
    return null;
  }

  static String? passwordValidator(String password) {
    if (password.isEmpty) {
      return null;
    }
    // if (!passwordRegex.hasMatch(password)) {
    //   return '';
    // }
    return null;
  }
}
