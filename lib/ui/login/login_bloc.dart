import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/login_otp.dart';
import 'package:vendor/model/login_response.dart';
import 'package:vendor/ui/login/login_event.dart';
import 'package:vendor/ui/login/login_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginIntialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is GetLoginEvent) {
      yield LoadingState();
      yield* getLogin(
        event.mobile,
      );
    }
    if (event is GetLoginOtpEvent) {
      yield* getLoginOtp(
        event.mobile,
        event.otp,
      );
    }
  }

  Stream<LoginState> getLogin(mobile) async* {
    if (await Network.isConnected()) {
      // try {
      LoginOtpResponse result = await apiProvider.login(mobile);
      log("$result");
      if (result.success) {
        yield GetLoginState(result);
      } else {
        yield GetLoginFailureState(message: result.message);
      }
      // } catch (error) {
      //   yield GetLoginFailureState(message: "internal sever error");
      // }
    } else {
      Fluttertoast.showToast(msg: "Turn on the internet");
    }
  }

  Stream<LoginState> getLoginOtp(mobile, otp) async* {
    if (await Network.isConnected()) {
      try {
        LoginResponse result = await apiProvider.verifyOtp(mobile, otp);
        if (result.success) {
          SharedPref.setBooleanPreference(SharedPref.LOGIN, true);
          SharedPref.setStringPreference(SharedPref.TOKEN, result.token!);
          SharedPref.setIntegerPreference(
              SharedPref.VENDORID, result.vendorId!);
          SharedPref.setIntegerPreference(
              SharedPref.USERSTATUS, result.vendorStatus!);

          baseOptions.headers
              .addAll({"Authorization": "bearer ${result.token!}"});
          yield GetLoginOtpState(result.message);
        } else {
          yield GetLoginFailureState(message: result.message);
        }
      } catch (error) {
        yield GetLoginFailureState(message: "internal sever error");
      }
    } else {
      Fluttertoast.showToast(msg: "Turn on  internet");
    }
  }
}
