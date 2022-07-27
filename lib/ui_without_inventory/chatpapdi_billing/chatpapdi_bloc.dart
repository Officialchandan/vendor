import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/chat_papdi_module/billing_chatpapdi.dart';
import 'package:vendor/model/chat_papdi_module/billing_chatpapdi_otp.dart';
import 'package:vendor/model/customer_number_response.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/partial_user_register.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/chatpapdi_event.dart';
import 'package:vendor/ui_without_inventory/chatpapdi_billing/chatpapdi_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

class ChatPapdiBillingCustomerNumberResponseBloc
    extends Bloc<ChatPapdiBillingCustomerNumberResponseEvent, ChatPapdiBillingCustomerNumberResponseState> {
  ChatPapdiBillingCustomerNumberResponseBloc() : super(ChatPapdiBillingCustomerNumberResponseIntialState());

  @override
  Stream<ChatPapdiBillingCustomerNumberResponseState> mapEventToState(
      ChatPapdiBillingCustomerNumberResponseEvent event) async* {
    if (event is GetChatPapdiBillingCustomerNumberResponseEvent) {
      if (event.mobile.length != 10) {
        yield GetChatPapdiBillingCustomerNumberResponseFailureState(
            message: "mobile_number_invalid_key".tr(), succes: false);
      } else {
        yield* getChatPapdiBillingCustomerNumberResponse(
          event.mobile,
        );
      }
    }
    if (event is GetDirectBillingCheckBoxEvent) {
      yield GetChatPapdiBillingOtpLoadingstate();
      yield DirectBillingCheckBoxState(index: event.index, isChecked: event.isChecked);
    }
    if (event is GetChatPapdiBillingEvent) {
      yield* getChatPapdiBilling(event.input);
    }

    if (event is GetChatPapdiBillingOtpEvent) {
      yield* getChatPapdiBillingOtp(event.input);
    }

    if (event is GetChatPapdiPartialUserRegisterEvent) {
      yield* getChatPapdiPartialUserRegister(event.input);
    }
    if (event is ChatPapdiCheckBoxEvent) {
      yield GetChatPapdiPartialUserLoadingstate();
      yield ChatPapdiCheckboxState(isChecked: event.isChecked);
    }
    if (event is GetDirectBillingCategoryEvent) {
      yield* getVendorCategoryByIdResponse();
    }
  }

  Stream<ChatPapdiBillingCustomerNumberResponseState> getChatPapdiBillingCustomerNumberResponse(mobile) async* {
    if (await Network.isConnected()) {
      EasyLoading.show();
      yield GetChatPapdiBillingCustomerNumberResponseLoadingstate();
      EasyLoading.dismiss();
      try {
        CustomerNumberResponse result = await apiProvider.getCustomerCoins(mobile);
        log("$result");
        if (result.success) {
          yield GetChatPapdiBillingCustomerNumberResponseState(
              message: result.message,
              data: result.data!.walletBalance,
              succes: result.success,
              firstName: result.data!.firstName,
              lastName: result.data!.lastName,
              status: result.cust_reg_status);
        } else {
          Utility.showToast(msg: result.message);
          yield GetChatPapdiBillingCustomerNumberResponseFailureState(
              message: result.message, succes: result.success, status: result.cust_reg_status);
        }
      } catch (error) {
        yield GetChatPapdiBillingCustomerNumberResponseFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }

  Stream<ChatPapdiBillingCustomerNumberResponseState> getChatPapdiBilling(input) async* {
    if (await Network.isConnected()) {
      yield GetChatPapdiBillingLoadingstate();
      try {
        ChatPapdiResponse result = await apiProvider.getChatPapdiBilling(input);
        log("$result");
        if (result.success) {
          SharedPref.setStringPreference(SharedPref.VendorCoin, result.data!.vendorAvailableCoins);
          yield GetChatPapdiBillingState(message: result.message, data: result.data!, succes: result.success);
        } else {
          Utility.showToast(msg: result.message);
          yield GetChatPapdiBillingFailureState(message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetChatPapdiBillingFailureState(message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }

  Stream<ChatPapdiBillingCustomerNumberResponseState> getChatPapdiBillingOtp(input) async* {
    if (await Network.isConnected()) {
      yield GetChatPapdiBillingOtpLoadingstate();
      try {
        ChatPapdiOtpResponse result = await apiProvider.getChatPapdiOtp(input);
        log("$result");
        if (result.success) {
          yield GetChatPapdiBillingOtpState(message: result.message, data: result.message, succes: result.success);
        } else {
          Utility.showToast(msg: result.message);
          yield GetChatPapdiBillingOtpFailureState(message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetChatPapdiBillingOtpFailureState(message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }

  Stream<ChatPapdiBillingCustomerNumberResponseState> getChatPapdiPartialUserRegister(input) async* {
    if (await Network.isConnected()) {
      try {
        PartialUserRegisterResponse result = await apiProvider.getChatPapdiPatialUserRegister(input);
        log("$result");
        if (result.success) {
          yield GetChatPapdiPartialUserState(message: result.message, data: result.message, succes: result.success);
        } else {
          Utility.showToast(msg: result.message);
          yield GetChatPapdiPartialUserFailureState(message: result.message, succes: result.success);
        }
      } catch (error) {
        yield GetChatPapdiPartialUserFailureState(message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }

  Stream<ChatPapdiBillingCustomerNumberResponseState> getVendorCategoryByIdResponse() async* {
    if (await Network.isConnected()) {
      yield GetDirectBillingCategoryByVendorIdLoadingstate();
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
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }
}
