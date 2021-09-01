import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/login_otp.dart';
import 'package:vendor/model/login_response.dart';
import 'package:vendor/provider/Endpoint.dart';
import 'package:vendor/provider/server_error.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../main.dart';

class ApiProvider {
  var client = http.Client();

  Future<LoginOtpResponse> login(mobile) async {
    log("chl gyi");
    try {
      Response res = await dio.post(Endpoint.GENERATE_OTP, data: {"mobile": mobile});
      print("${res.data}");
      return LoginOtpResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      print("Exception occurred: $message stackTrace: $stacktrace");
      return LoginOtpResponse(success: false, message: message);
    }
  }

  Future<LoginResponse> verifyOtp(mobile, otp) async {
    log("chl gyi ${mobile + otp}");
    try {
      Response res = await dio.post(Endpoint.VERIFY_OTP, data: {"mobile": mobile, "otp": otp});
      log("chl gyi 2${res}");

      return LoginResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Something Went wrong";
      }
      print("Exception occurred: $message stackTrace: $error");
      return LoginResponse(success: false, message: message);
    }
  }

  Future<CustomerNumberResponse> getCustomerCoins(mobile) async {
    log("chl gyi ${mobile}");
    try {
      var token = await SharedPref.getStringPreference('token');

      Response res = await dio.post(
        Endpoint.GET_CUSTOMER_COINS,
        data: {"mobile": mobile},
      );
      log("chl gyi 2${res}");

      return CustomerNumberResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message = "Customer not registered with us! Kindly first registered yourself with MyProfit";
      }
      print("Exception occurred: $message stackTrace: $error");
      return CustomerNumberResponse(success: false, message: message);
    }
  }
}
