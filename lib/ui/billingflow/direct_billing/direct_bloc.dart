import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/direct_billing.dart';
import 'package:vendor/model/direct_billing_otp.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/partial_user_register.dart';
import 'package:vendor/ui/billingflow/direct_billing/direct_event.dart';
import 'package:vendor/ui/billingflow/direct_billing/direct_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';

class DirectBillingCustomerNumberResponseBloc
    extends Bloc<DirectBillingCustomerNumberResponseEvent, DirectBillingCustomerNumberResponseState> {
  DirectBillingCustomerNumberResponseBloc() : super(DirectBillingCustomerNumberResponseIntialState());

  @override
  Stream<DirectBillingCustomerNumberResponseState> mapEventToState(
      DirectBillingCustomerNumberResponseEvent event) async* {
    if (event is GetDirectBillingCustomerNumberResponseEvent) {
      if (event.mobile.length != 10) {
        yield GetDirectBillingCustomerNumberResponseFailureState(
            message: "mobile_number_invalid_key".tr(), succes: false);
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

    if (event is GetDirectBillingPartialUserRegisterEvent) {
      yield* getDirectBillingPartialUserRegister(event.input);
    }

    if (event is GetDirectBillingCategoryEvent) {
      yield GetDirectBillingPartialUserLoadingstate();
      yield* getVendorCategoryByIdResponse();
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
              message: result.message,
              data: result.data!.walletBalance,
              succes: result.success,
              status: result.cust_reg_status);
        } else {
          Fluttertoast.showToast(msg: result.message, backgroundColor: ColorPrimary);
          yield GetDirectBillingCustomerNumberResponseFailureState(
              message: result.message, succes: result.success, status: result.cust_reg_status);
        }
      } catch (error) {
        yield GetDirectBillingCustomerNumberResponseFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Fluttertoast.showToast(msg: "please_check_your_internet_connection_key".tr(), backgroundColor: ColorPrimary);
    }
  }

  Stream<DirectBillingCustomerNumberResponseState> getDirectBilling(input) async* {
    if (await Network.isConnected()) {
      yield GetDirectBillingLoadingstate();
      try {
        DirectBillingResponse result = await apiProvider.getDirectBilling(input);
        log("$result");
        if (result.success) {
          SharedPref.setStringPreference(SharedPref.VendorCoin, result.data!.vendorAvailableCoins);
          log("VendorCoin------->${result.data!.vendorAvailableCoins}");
          yield GetDirectBillingState(message: result.message, data: result.data!, succes: result.success);
        } else {
          Fluttertoast.showToast(msg: result.message, backgroundColor: ColorPrimary);
          yield GetDirectBillingFailureState(message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetDirectBillingFailureState(message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Fluttertoast.showToast(msg: "please_check_your_internet_connection_key".tr(), backgroundColor: ColorPrimary);
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
        yield GetDirectBillingOtpFailureState(message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Fluttertoast.showToast(msg: "please_check_your_internet_connection_key".tr(), backgroundColor: ColorPrimary);
    }
  }

  Stream<DirectBillingCustomerNumberResponseState> getDirectBillingPartialUserRegister(input) async* {
    if (await Network.isConnected()) {
      try {
        PartialUserRegisterResponse result = await apiProvider.getChatPapdiPatialUserRegister(input);
        log("$result");
        if (result.success) {
          yield GetDirectBillingPartialUserState(message: result.message, data: result.message, succes: result.success);
        } else {
          Fluttertoast.showToast(msg: result.message, backgroundColor: ColorPrimary);
          yield GetDirectBillingPartialUserFailureState(message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetDirectBillingPartialUserFailureState(message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Fluttertoast.showToast(msg: "please_check_your_internet_connection_key".tr(), backgroundColor: ColorPrimary);
    }
  }

  Stream<DirectBillingCustomerNumberResponseState> getVendorCategoryByIdResponse() async* {
    if (await Network.isConnected()) {
      yield GetDirectBillingLoadingstate();
      try {
        GetCategoriesResponse result = await apiProvider.getCategoryByVendorId();
        log("$result");
        if (result.success) {
          yield GetDirectBillingCategoryByVendorIdState(message: result.message, data: result.data!);
        } else {
          yield GetDirectBillingCategoryByVendorIdFailureState(message: result.message);
        }
      } catch (error) {
        yield GetDirectBillingCategoryByVendorIdFailureState(message: "internal_server_error_key".tr());
      }
    } else {
      Fluttertoast.showToast(msg: "please_check_your_internet_connection_key".tr(), backgroundColor: ColorPrimary);
    }
  }
}
