import 'dart:convert';

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:vendor/model/customer_number_response.dart';

import 'package:vendor/model/login_otp.dart';
import 'package:vendor/model/login_response.dart';
import 'package:vendor/provider/server_error.dart';
import 'package:vendor/utility/sharedpref.dart';

import '../main.dart';

class ApiProvider {
  var client = http.Client();
  var baseUrl = "http://vendor.tekzee.in/api/v1";

  // Future<LoginResponse> logIn(mobile, otp) async {
  //   final client = new http.Client();

  //   var data = {
  //     "mobile": mobile,
  //     "otp": otp,
  //   };
  //   final response = await client.post(
  //     Uri.parse('$baseUrl/verifyOTP'),
  //     body: data,
  //   );
  //   print("ssggsggsgsg+${response.body.toString()}");
  //   log(response.body.toString());
  //   return LoginResponse.fromJson(response.body);
  // }
  Future<LoginOtpResponse> login(mobile) async {
    log("chl gyi");
    try {
      Response res = await dio.post('$baseUrl/genereateOTP',
          //options: Options(
          // headers: {"Authorization": "Bearer ${SharedPref.getString('token')}"},
          //)
          data: {"mobile": mobile});
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
      Response res = await dio
          .post('$baseUrl/verifyOTP', data: {"mobile": mobile, "otp": otp});
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

      Response res = await dio.post('$baseUrl/getCustomerCoins',
          data: {"mobile": mobile},
          options: Options(
            headers: {"Authorization": "Bearer ${token}"},
          ));
      log("chl gyi 2${res}");

      return CustomerNumberResponse.fromJson(res.toString());
    } catch (error, stacktrace) {
      String message = "";
      if (error is DioError) {
        ServerError e = ServerError.withError(error: error);
        message = e.getErrorMessage();
      } else {
        message =
            "Customer not registered with us! Kindly first registered yourself with MyProfit";
      }
      print("Exception occurred: $message stackTrace: $error");
      return CustomerNumberResponse(success: false, message: message);
    }
  }
}
