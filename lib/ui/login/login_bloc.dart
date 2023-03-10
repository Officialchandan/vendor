import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/login_otp.dart';
import 'package:vendor/model/login_response.dart';
import 'package:vendor/ui/login/login_event.dart';
import 'package:vendor/ui/login/login_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is GetLoginEvent) {
      yield LoadingState();
      yield* getLogin(
        event.mobile,
      );
    }
    if (event is GetLoginOtpEvent) {
      yield LoadingState();
      yield* getLoginOtp(
        event.mobile,
        event.otp,
      );
    }
    if (event is GetotpResendEvent) {
      yield LoadingState();
      yield* resendOtp(
        event.mobile,
      );
    }
  }

  Stream<LoginState> getLogin(mobile) async* {
    if (await Network.isConnected()) {
      LoginOtpResponse result = await apiProvider.login(mobile);
      EasyLoading.dismiss();
      log("$result");
      if (result.success) {
        baseOptions.headers.addAll({
          "languagecode":
              "${await SharedPref.getStringPreference(SharedPref.SELECTEDLANG)}"
        });
        yield GetLoginState(result);
      } else {
        yield GetLoginFailureState(message: result.message);
      }
    } else {
      EasyLoading.dismiss();
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }

  Stream<LoginState> resendOtp(mobile) async* {
    if (await Network.isConnected()) {
      LoginOtpResponse result = await apiProvider.login(mobile);
      EasyLoading.dismiss();
      log("$result");
      if (result.success) {
        baseOptions.headers.addAll({
          "languagecode":
              "${await SharedPref.getStringPreference(SharedPref.SELECTEDLANG)}"
        });
        yield GetResendOptState(isCheckStatus: result.success);
      } else {
        yield GetLoginFailureState(message: result.message);
      }
    } else {
      EasyLoading.dismiss();
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }

  Stream<LoginState> getLoginOtp(mobile, otp) async* {
    if (await Network.isConnected()) {
      //try {
      LoginResponse result = await apiProvider.verifyOtp(mobile, otp);
      EasyLoading.dismiss();
      if (result.success) {
        SharedPref.setBooleanPreference(SharedPref.LOGIN, true);
        SharedPref.setStringPreference(SharedPref.TOKEN, result.token!);
        SharedPref.setStringPreference(
            SharedPref.VENDORNAME, result.vendorName!);
        SharedPref.setIntegerPreference(SharedPref.VENDORID, result.vendorId!);
        SharedPref.setIntegerPreference(
            SharedPref.USERSTATUS, result.vendorStatus!);
        SharedPref.setStringPreference(SharedPref.USERNAME, result.vendorName!);
        SharedPref.setStringPreference(
            SharedPref.USERNUMBER, result.vendorMobile!);
        SharedPref.setStringPreference(SharedPref.OWNERNAME, result.ownerName!);
        SharedPref.setStringPreference(
            SharedPref.VendorCoin, result.vendorCoins!);
        log("VendorCoin------->${result.vendorCoins!}");
        log("VendorCoin------->${result.vendorName!}");
        if (result.commission!.isNotEmpty) {
          SharedPref.setStringPreference(
              SharedPref.COMMISSION, result.commission!);
        }

        baseOptions.headers
            .addAll({"Authorization": "bearer ${result.token!}"});
        yield GetLoginOtpState(result.message);
      } else {
        yield GetLoginFailureState(message: result.message);
      }
      // } catch (error) {
      //   yield GetLoginFailureState(message: "internal_server_error_key".tr());
      // }
    } else {
      EasyLoading.dismiss();
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }
}
