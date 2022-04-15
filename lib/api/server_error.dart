import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vendor/ui/login/login_screen.dart';
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
        } else {
          _errorMessage = "Internal server Error";
        }

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
                content: Text("Your session has been expired! Please login again"),
                contentPadding: EdgeInsets.all(15),
                actions: [
                  TextButton(
                      onPressed: () async {
                        SharedPref.clearSharedPreference(context);
                        Navigator.pushAndRemoveUntil(
                            context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                      },
                      child: Text("Ok"))
                ],
              ),
            ));

    // EasyLoading.showError("Your session has been expired! Please login again",);
  }
}
