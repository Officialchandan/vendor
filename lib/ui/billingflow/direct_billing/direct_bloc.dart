import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/direct_billing.dart';
import 'package:vendor/model/direct_billing_otp.dart';
import 'package:vendor/ui/billingflow/direct_billing/direct_event.dart';
import 'package:vendor/ui/billingflow/direct_billing/direct_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';

class DirectBillingCustomerNumberResponseBloc
    extends Bloc<DirectBillingCustomerNumberResponseEvent, DirectBillingCustomerNumberResponseState> {
  DirectBillingCustomerNumberResponseBloc() : super(DirectBillingCustomerNumberResponseIntialState());

  @override
  Stream<DirectBillingCustomerNumberResponseState> mapEventToState(DirectBillingCustomerNumberResponseEvent event) async* {
    if (event is GetDirectBillingCustomerNumberResponseEvent) {
      if (event.mobile.length != 10) {
        yield GetDirectBillingCustomerNumberResponseFailureState(message: "Mobile Number Invalid", succes: false);
      } else {
        yield* getDirectBillingCustomerNumberResponse(
          event.mobile,
        );
      }
    }

    if (event is GetDirectBillingEvent) {
      yield* getDirectBilling(event.input);
    }

    if (event is GetDirectBillingOtpEvent) {
      yield* getDirectBillingOtp(event.input);
    }
  }

  Stream<DirectBillingCustomerNumberResponseState> getDirectBillingCustomerNumberResponse(mobile) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      yield GetDirectBillingCustomerNumberResponseLoadingstate();
      EasyLoading.dismiss();
      try {
        CustomerNumberResponse result = await apiProvider.getCustomerCoins(mobile);
        log("$result");
        if (result.success) {
          yield GetDirectBillingCustomerNumberResponseState(
              message: result.message, data: result.data!.walletBalance, succes: result.success);
        } else {
          Fluttertoast.showToast(msg: result.message, backgroundColor: ColorPrimary);
          yield GetDirectBillingCustomerNumberResponseFailureState(message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetDirectBillingCustomerNumberResponseFailureState(message: "internal Server error", succes: false);
      }
    } else {
      Fluttertoast.showToast(msg: "Turn on the internet");
    }
  }

  Stream<DirectBillingCustomerNumberResponseState> getDirectBilling(input) async* {
    if (await Network.isConnected()) {
      yield GetDirectBillingLoadingstate();
      try {
        DirectBillingResponse result = await apiProvider.getDirectBilling(input);
        log("$result");
        if (result.success) {
          yield GetDirectBillingState(message: result.message, data: result.data!, succes: result.success);
        } else {
          Fluttertoast.showToast(msg: result.message, backgroundColor: ColorPrimary);
          yield GetDirectBillingFailureState(message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetDirectBillingFailureState(message: "internal Server error", succes: false);
      }
    } else {
      Fluttertoast.showToast(msg: "Turn on the internet");
    }
  }

  Stream<DirectBillingCustomerNumberResponseState> getDirectBillingOtp(input) async* {
    if (await Network.isConnected()) {
      yield GetDirectBillingOtpLoadingstate();
      try {
        DirectBillingOtpResponse result = await apiProvider.getDirectBillingOtp(input);
        log("$result");
        if (result.success) {
          yield GetDirectBillingOtpState(message: result.message, data: result.message, succes: result.success);
        } else {
          Fluttertoast.showToast(msg: result.message, backgroundColor: ColorPrimary);
          yield GetDirectBillingOtpFailureState(message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetDirectBillingOtpFailureState(message: "internal Server error", succes: false);
      }
    } else {
      Fluttertoast.showToast(msg: "Turn on the internet");
    }
  }
}
