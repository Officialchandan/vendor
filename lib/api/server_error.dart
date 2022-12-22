import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/ui/login/login_screen.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../main.dart';

class ServerError implements Exception {
  int? _errorCode = 200;
  String _errorMessage = "";

  ServerError.withError({required DioError? error}) {
    _handleError(error!);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioError error) async {
    _errorCode = error.response!.statusCode!;
    print(error);
    print(error.message);
    switch (error.type) {
      case DioErrorType.cancel:
        _errorMessage = "request_was_cancelled_key".tr();
        break;
      case DioErrorType.connectTimeout:
        _errorMessage = "connection_timeout_key".tr();
        break;
      case DioErrorType.other:
        _errorMessage = "connection_failed_due_to_internet_connection_key";
        break;
      case DioErrorType.receiveTimeout:
        _errorMessage = "Receive timeout in connection";
        break;
      case DioErrorType.response:
        if (error.response!.statusCode == 401) {
          print("come here-->");
          _errorMessage = "";
          logout();
          //resetapp();
        }
        if (error.response!.statusCode == 404) {
          print("come here-->");
          Fluttertoast.showToast(
              msg: "Request not found. Please try again after some time.",
              backgroundColor: ColorPrimary);
        }
        if (error.response!.statusCode == 202) {
          print("come here-->");

          Fluttertoast.showToast(
              msg:
                  "Network congestion error. Pleasee check your internet connection.",
              backgroundColor: ColorPrimary);
        }
        if (error.response!.statusCode == 429) {
          print("come here-->");

          Fluttertoast.showToast(
              msg:
                  "Network congestion error.. Please try again after some time.",
              backgroundColor: ColorPrimary);
        }
        if (error.response!.statusCode == 500) {
          print("come here-->");
          Fluttertoast.showToast(
              msg: "Something went wrong. Please try again after some time.",
              backgroundColor: ColorPrimary);
          resetapp();
        }
        if (error.response!.statusCode == 502) {
          print("come here-->");
          Fluttertoast.showToast(
              msg:
                  "Network congestion error.. Please try again after some time.",
              backgroundColor: ColorPrimary);
        }
        if (error.response!.statusCode == 503) {
          print("come here-->");
          Fluttertoast.showToast(
              msg:
                  "The server is currently unavailable. Please try again after some time.",
              backgroundColor: ColorPrimary);
        }
        if (error.response!.statusCode == 504) {
          print("come here-->");
          Fluttertoast.showToast(
              msg: "Gateway timeout. Please try again after some time.",
              backgroundColor: ColorPrimary);
        }

        break;

        break;

      case DioErrorType.sendTimeout:
        _errorMessage = "Receive timeout in send request";
        break;
    }
    return _errorMessage;
  }

  void logout() async {
    double devicewidth = 300;

    showDialog(
        barrierDismissible: false,
        context: navigationService.navigatorKey.currentContext!,
        builder: (context) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AlertDialog(
                content:
                    Text("Your session has been expired! Please login again"),
                contentPadding: EdgeInsets.all(15),
                actions: [
                  TextButton(
                      onPressed: () async {
                        SharedPref.clearSharedPreference(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false);
                      },
                      child: Text("Ok"))
                ],
              ),
            ));

    // EasyLoading.showError("Your session has been expired! Please login again",);
  }

  void resetapp() async {
    showDialog(
        barrierDismissible: false,
        context: navigationService.navigatorKey.currentContext!,
        builder: (context) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AlertDialog(
                content: Text(
                  "restart_502_error".tr(),
                  style: GoogleFonts.openSans(
                    color: Colors.black,
                  ),
                ),
                contentPadding: EdgeInsets.all(15),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await Phoenix.rebirth(context);
                      },
                      child: Text("restart_key".tr()))
                ],
              ),
            ));
    // EasyLoading.showError("Your session has been expired! Please login again",);
  }
}
