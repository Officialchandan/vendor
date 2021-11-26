import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/vendor_profile_response.dart';
import 'package:vendor/ui/account_management/account_management_screen/account_management_event.dart';
import 'package:vendor/ui/account_management/account_management_screen/account_management_state.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';

class AccountManagementBloc
    extends Bloc<AccountManagementEvent, AccountManagementState> {
  AccountManagementBloc(AccountManagementState initialState)
      : super(initialState);

  @override
  Stream<AccountManagementState> mapEventToState(
      AccountManagementEvent event) async* {
    if (event is GetAccountManagementEvent) {
      yield* getVendorProfile();
    }
  }

  Stream<AccountManagementState> getVendorProfile() async* {
    if (await Network.isConnected()) {
      yield GetAccountManagementLoadingstate();
      try {
        VendorDetailResponse result =
            await apiProvider.getVendorProfileDetail();
        log("$result");
        if (result.success) {
          yield GetAccountManagementState(
              message: result.message,
              data: result.data,
              succes: result.message);
        } else {
          yield GetAccountManagementLoadingstate();
        }
      } catch (error) {
        yield GetAccountManagementFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Fluttertoast.showToast(
          msg: "please_check_your_internet_connection_key".tr(),
          backgroundColor: ColorPrimary);
    }
  }
}