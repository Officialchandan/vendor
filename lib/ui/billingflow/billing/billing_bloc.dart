import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/getdue_amount_by_day.dart';
import 'package:vendor/model/partial_user_register.dart';
import 'package:vendor/ui/billingflow/billing/billing_event.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

import '../../../utility/sharedpref.dart';
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
    if (event is GetBillingDueAmmountEvent) {
      yield* getDueAmountResponse();
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
              firstName: result.data!.firstName,
              lastName: result.data!.lastName,
              succes: result.success);
        } else {
          Utility.showToast(
            msg: result.message,
          );
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
      Utility.showToast(
        msg: "please_check_your_internet_connection_key".tr(),
      );
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
          add(GetBillingDueAmmountEvent());
        } else {
          yield GetCategoryByVendorIdFailureState(message: result.message);
        }
      } catch (error) {
        yield GetCategoryByVendorIdFailureState(
            message: "internal_server_error_key".tr());
      }
    } else {
      Utility.showToast(
        msg: "please_check_your_internet_connection_key".tr(),
      );
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
          Utility.showToast(msg: result.message);
          yield GetBillingPartialUserFailureState(
              message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetBillingPartialUserFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(
        msg: "please_check_your_internet_connection_key".tr(),
      );
    }
  }

  Stream<CustomerNumberResponseState> getDueAmountResponse() async* {
    if (await Network.isConnected()) {
      try {
        GetDueAmountByDay result = await apiProvider.getDueAmountByVendorId();
        log("$result");
        if (result.success) {
          // var now = DateTime.now();
          // var initalizetime = new DateFormat('yyyy-MM-dd HH:mm:ss').parse(
          //     '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} 12:00:00');
          // print(initalizetime);
          // final difference = initalizetime.difference(now).inMinutes;
          // bool timeon = false;
          // print(difference);
          // if (difference > 0) {
          //   print("Delayed true");
          //   timeon = false;
          //   Future.delayed(Duration(minutes: difference), () {
          //     print("Delayed Running");
          //     add(GetBillingDueAmmountEvent());
          //   });
          // } else {
          //   timeon = true;
          // }
          /*
      ? iclude this condition as well in bellow conidtion if you want timer
        {&& timeon} and uncomment the up one 
    */
          if (result.data!.totalDue! - result.data!.todayDue! > 0) {
            print("done");
            await SharedPref.setBooleanPreference("isDueAmount", true);
            yield GetBillingDueAmoutResponseState(
                message: result.message,
                data: result.data!,
                status: result.success);
          } else {
            await SharedPref.setBooleanPreference("isDueAmount", false);
          }
        } else {
          yield GetBillingPartialUserFailureState(
              message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetBillingPartialUserFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }
}
