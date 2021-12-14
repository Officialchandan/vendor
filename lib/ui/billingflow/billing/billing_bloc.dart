import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/partial_user_register.dart';
import 'package:vendor/ui/billingflow/billing/billing_event.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';

import 'billing_state.dart';

class CustomerNumberResponseBloc
    extends Bloc<CustomerNumberResponseEvent, CustomerNumberResponseState> {
  CustomerNumberResponseBloc() : super(CustomerNumberResponseIntialState());

  @override
  Stream<CustomerNumberResponseState> mapEventToState(
      CustomerNumberResponseEvent event) async* {
    if (event is GetCustomerNumberResponseEvent) {
      if (event.mobile.length != 10) {
        yield GetCustomerNumberResponseFailureState(
            message: "mobile_number_invalid_key".tr(), succes: false);
      } else {
        yield* getCustomerNumberResponse(
          event.mobile,
        );
      }
    }
    if (event is GetVendorCategoryEvent) {
      yield* getVendorCategoryByIdResponse();
    }

    if (event is GetBillingPartialUserRegisterEvent) {
      yield* getPartialUserRegister(event.input);
    }
    // if(event is)
  }

  Stream<CustomerNumberResponseState> getCustomerNumberResponse(mobile) async* {
    if (await Network.isConnected()) {
      yield GetCustomerNumberResponseLoadingstate();
      try {
        CustomerNumberResponse result =
            await apiProvider.getCustomerCoins(mobile);
        log("$result");
        if (result.success) {
          yield GetCustomerNumberResponseState(
              message: result.message,
              data: result.data!.walletBalance,
              status: result.cust_reg_status,
              succes: result.success);
        } else {
          Fluttertoast.showToast(
              msg: result.message, backgroundColor: ColorPrimary);
          yield GetCustomerNumberResponseFailureState(
            message: result.message,
            succes: result.success,
            status: result.cust_reg_status,
          );
        }
      } catch (error) {
        yield GetCustomerNumberResponseFailureState(
          message: "internal_server_error_key".tr(),
          succes: false,
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: "please_check_your_internet_connection_key".tr(),
          backgroundColor: ColorPrimary);
    }
  }

  Stream<CustomerNumberResponseState> getVendorCategoryByIdResponse() async* {
    if (await Network.isConnected()) {
      yield GetCustomerNumberResponseLoadingstate();
      try {
        GetCategoriesResponse result =
            await apiProvider.getCategoryByVendorId();
        log("$result");
        if (result.success) {
          yield GetCategoryByVendorIdState(
              message: result.message, data: result.data!);
        } else {
          yield GetCategoryByVendorIdFailureState(message: result.message);
        }
      } catch (error) {
        yield GetCategoryByVendorIdFailureState(
            message: "internal_server_error_key".tr());
      }
    } else {
      Fluttertoast.showToast(
          msg: "please_check_your_internet_connection_key".tr(),
          backgroundColor: ColorPrimary);
    }
  }

  Stream<CustomerNumberResponseState> getPartialUserRegister(input) async* {
    if (await Network.isConnected()) {
      try {
        PartialUserRegisterResponse result =
            await apiProvider.getChatPapdiPatialUserRegister(input);
        log("$result");
        if (result.success) {
          yield GetBillingPartialUserState(
              message: result.message,
              data: result.message,
              succes: result.success);
        } else {
          Fluttertoast.showToast(
              msg: result.message, backgroundColor: ColorPrimary);
          yield GetBillingPartialUserFailureState(
              message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetBillingPartialUserFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Fluttertoast.showToast(
          msg: "please_check_your_internet_connection_key".tr(),
          backgroundColor: ColorPrimary);
    }
  }
}
