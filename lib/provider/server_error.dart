import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:vendor/UI/login/login_screen.dart';
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
        _errorMessage = "Request was cancelled";
        break;
      case DioErrorType.connectTimeout:
        _errorMessage = "Connection timeout";
        break;
      case DioErrorType.other:
        _errorMessage = "Connection failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        _errorMessage = "Receive timeout in connection";
        break;
      case DioErrorType.response:
        _errorMessage =
            "Received invalid status code: ${error.response!.statusCode}";
        if (error.response!.statusCode == 401) {
          print("come here-->");

          logout();
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
        builder: (context) => AlertDialog(
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
            ));

    // EasyLoading.showError("Your session has been expired! Please login again",);
  }
}
