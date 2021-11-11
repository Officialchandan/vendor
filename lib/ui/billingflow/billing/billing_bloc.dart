import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:vendor/main.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/get_vendorcategory_id.dart';
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
            message: "Mobile Number Invalid", succes: false);
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
              status: result.status,
              succes: result.success);
        } else {
          Fluttertoast.showToast(
              msg: result.message, backgroundColor: ColorPrimary);
          yield GetCustomerNumberResponseFailureState(
            message: result.message,
            succes: result.success,
            status: result.status,
          );
        }
      } catch (error) {
        yield GetCustomerNumberResponseFailureState(
          message: "internal Server error",
          succes: false,
        );
      }
    } else {
      Fluttertoast.showToast(msg: "Turn on the internet");
    }
  }

  Stream<CustomerNumberResponseState> getVendorCategoryByIdResponse() async* {
    if (await Network.isConnected()) {
      yield GetCustomerNumberResponseLoadingstate();
      try {
        GetVendorCategoryById result =
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
            message: "internal Server error");
      }
    } else {
      Fluttertoast.showToast(msg: "Turn on the internet");
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
            message: "internal Server error", succes: false);
      }
    } else {
      Fluttertoast.showToast(msg: "Turn on the internet");
    }
  }
}
