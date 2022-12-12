import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/direct_billing.dart';
import 'package:vendor/model/direct_billing_otp.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/partial_user_register.dart';
import 'package:vendor/ui/billingflow/direct_billing/direct_event.dart';
import 'package:vendor/ui/billingflow/direct_billing/direct_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

import '../../../model/getdue_amount_by_day.dart';

class DirectBillingCustomerNumberResponseBloc extends Bloc<
    DirectBillingCustomerNumberResponseEvent,
    DirectBillingCustomerNumberResponseState> {
  DirectBillingCustomerNumberResponseBloc()
      : super(DirectBillingCustomerNumberResponseIntialState());

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
    if (event is GetDirectBillingDueAmmountEvent) {
      yield* getDueAmountResponse();
    }
    if (event is GetDirectBillingEvent) {
      yield* getDirectBilling(event.input);
    }
    if (event is ResendOtpDirectBillingEvent) {
      yield* otpResendDirectBilling(event.input);
    }

    if (event is GetDirectBillingOtpEvent) {
      yield* getDirectBillingOtp(event.input);
    }

    if (event is GetDirectBillingPartialUserRegisterEvent) {
      yield* getDirectBillingPartialUserRegister(event.input);
    }

    if (event is GetDirectBillingCategoryEvent) {
      yield* getVendorCategoryByIdResponse();
    }

    if (event is GetDirectBillingCheckBoxEvent) {
      yield DirectBillingLoadingState();
      yield DirectBillingCheckBoxState(
          index: event.index, isChecked: event.isChecked);
    }
    if (event is GetDirectBillingRedeemCheckBoxEvent) {
      yield DirectBillingLoadingState();
      yield DirectBillingRedeemCheckBoxState(isChecked: event.isChecked);
    }
  }

  Stream<DirectBillingCustomerNumberResponseState>
      getDirectBillingCustomerNumberResponse(mobile) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      yield GetDirectBillingCustomerNumberResponseLoadingstate();
      EasyLoading.dismiss();
      try {
        CustomerNumberResponse result =
            await apiProvider.getCustomerCoins(mobile);

        log("$result");
        if (result.success) {
          yield GetDirectBillingCustomerNumberResponseState(
              message: result.message,
              data: result.data!.walletBalance,
              succes: result.success,
              firstName: result.data!.firstName,
              lastName: result.data!.lastName,
              status: result.cust_reg_status);
        } else {
          Utility.showToast(msg: result.message);
          yield GetDirectBillingCustomerNumberResponseFailureState(
              message: result.message,
              succes: result.success,
              status: result.cust_reg_status);
        }
      } catch (error) {
        yield GetDirectBillingCustomerNumberResponseFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }

  Stream<DirectBillingCustomerNumberResponseState> getDirectBilling(
      input) async* {
    if (true) {
      // yield GetDirectBillingLoadingstate();
      try {
        DirectBillingResponse result =
            await apiProvider.getDirectBilling(input);
        log("$result");
        if (result.success) {
          SharedPref.setStringPreference(
              SharedPref.VendorCoin, result.data!.vendorAvailableCoins);
          log("VendorCoin------->${result.data!.vendorAvailableCoins}");
          yield GetDirectBillingState(
              message: result.message,
              data: result.data!,
              succes: result.success);
        } else {
          Utility.showToast(
            msg: result.message,
          );
          yield GetDirectBillingFailureState(
              message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetDirectBillingFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      // Utility.showToast(
      //   msg: "please_check_your_internet_connection_key".tr(),
      // );
    }
  }

  Stream<DirectBillingCustomerNumberResponseState> otpResendDirectBilling(
      input) async* {
    if (await Network.isConnected()) {
      // yield GetDirectBillingLoadingstate();
      try {
        DirectBillingResponse result =
            await apiProvider.getDirectBilling(input);
        log("$result");
        if (result.success) {
          SharedPref.setStringPreference(
              SharedPref.VendorCoin, result.data!.vendorAvailableCoins);
          log("VendorCoin------->${result.data!.vendorAvailableCoins}");
          yield ResendOtpDirectBillingState(
              message: result.message,
              data: result.data!,
              succes: result.success);
        } else {
          Utility.showToast(
            msg: result.message,
          );
          yield GetDirectBillingFailureState(
              message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetDirectBillingFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(
        msg: "please_check_your_internet_connection_key".tr(),
      );
    }
  }

  Stream<DirectBillingCustomerNumberResponseState> getDirectBillingOtp(
      input) async* {
    if (await Network.isConnected()) {
      // yield GetDirectBillingOtpLoadingstate();
      try {
        EasyLoading.show();
        DirectBillingOtpResponse result =
            await apiProvider.getDirectBillingOtp(input);
        log("$result");
        if (result.success) {
          EasyLoading.dismiss();
          yield GetDirectBillingOtpState(
              message: result.message,
              data: result.message,
              succes: result.success);
        } else {
          EasyLoading.dismiss();
          Utility.showToast(
            msg: result.message,
          );
          yield GetDirectBillingOtpFailureState(
              message: result.message, succes: result.success);
        }
      } catch (error) {
        EasyLoading.dismiss();
        yield GetDirectBillingOtpFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(
        msg: "please_check_your_internet_connection_key".tr(),
      );
    }
  }

  Stream<DirectBillingCustomerNumberResponseState>
      getDirectBillingPartialUserRegister(input) async* {
    if (await Network.isConnected()) {
      try {
        PartialUserRegisterResponse result =
            await apiProvider.getChatPapdiPatialUserRegister(input);
        log("$result");
        if (result.success) {
          yield GetDirectBillingPartialUserState(
              message: result.message,
              data: result.message,
              succes: result.success);
        } else {
          Utility.showToast(msg: result.message);
          yield GetDirectBillingPartialUserFailureState(
              message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetDirectBillingPartialUserFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }

  Stream<DirectBillingCustomerNumberResponseState>
      getVendorCategoryByIdResponse() async* {
    if (await Network.isConnected()) {
      yield GetDirectBillingLoadingstate();
      try {
        GetCategoriesResponse result =
            await apiProvider.getCategoryByVendorId();
        log("$result");
        if (result.success) {
          yield GetDirectBillingCategoryByVendorIdState(
              message: result.message, data: result.data!);
          add(GetDirectBillingDueAmmountEvent());
        } else {
          yield GetDirectBillingCategoryByVendorIdFailureState(
              message: result.message);
        }
      } catch (error) {
        yield GetDirectBillingCategoryByVendorIdFailureState(
            message: "internal_server_error_key".tr());
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }

  Stream<DirectBillingCustomerNumberResponseState>
      getDueAmountResponse() async* {
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
          //     add(GetDirectBillingDueAmmountEvent());
          //     //  getDueAmountResponse();
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
            yield GetDirectBillingDueAmoutResponseState(
                message: result.message,
                data: result.data!,
                status: result.success);
          } else {
            await SharedPref.setBooleanPreference("isDueAmount", false);
          }
        } else {
          yield GetDirectBillingCategoryByVendorIdFailureState(
              message: result.message);
        }
      } catch (error) {
        yield GetDirectBillingCategoryByVendorIdFailureState(
            message: "internal_server_error_key".tr());
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }
}
