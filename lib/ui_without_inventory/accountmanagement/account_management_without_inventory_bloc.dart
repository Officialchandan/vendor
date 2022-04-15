import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/vendor_profile_response.dart';
import 'package:vendor/ui_without_inventory/accountmanagement/account_management_without_inventory_event.dart';
import 'package:vendor/ui_without_inventory/accountmanagement/account_management_without_inventory_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class AccountManagementWithoutInventoryBloc
    extends Bloc<AccountManagementWithoutInventoryEvent, AccountManagementWithoutInventoryState> {
  AccountManagementWithoutInventoryBloc(AccountManagementWithoutInventoryState initialState) : super(initialState);

  @override
  Stream<AccountManagementWithoutInventoryState> mapEventToState(AccountManagementWithoutInventoryEvent event) async* {
    if (event is GetAccountManagementWithoutInventoryEvent) {
      yield* getVendorProfile();
    }
  }

  Stream<AccountManagementWithoutInventoryState> getVendorProfile() async* {
    if (await Network.isConnected()) {
      yield GetAccountManagementWithoutInventoryLoadingstate();
      try {
        VendorDetailResponse result = await apiProvider.getVendorProfileDetail();
        log("$result");
        if (result.success) {
          yield GetAccountManagementWithoutInventoryState(
            message: result.message,
            data: result.data,
            succes: result.message,
          );
        } else {
          yield GetAccountManagementWithoutInventoryLoadingstate();
        }
      } catch (error) {
        yield GetAccountManagementWithoutInventoryFailureState(
            message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(
        msg: "please_check_your_internet_connection_key".tr(),
      );
    }
  }
}
