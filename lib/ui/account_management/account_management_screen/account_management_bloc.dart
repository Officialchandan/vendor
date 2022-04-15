import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/vendor_profile_response.dart';
import 'package:vendor/ui/account_management/account_management_screen/account_management_event.dart';
import 'package:vendor/ui/account_management/account_management_screen/account_management_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class AccountManagementBloc extends Bloc<AccountManagementEvent, AccountManagementState> {
  AccountManagementBloc() : super(AccountManagementIntialState());

  @override
  Stream<AccountManagementState> mapEventToState(AccountManagementEvent event) async* {
    if (event is GetAccountManagementEvent) {
      yield GetAccountManagementLoadingstate();
      yield* getVendorProfile();
    }
  }

  Stream<AccountManagementState> getVendorProfile() async* {
    if (await Network.isConnected()) {
      VendorDetailResponse result = await apiProvider.getVendorProfileDetail();

      if (result.success) {
        yield GetAccountManagementState(message: result.message, data: result.data, succes: result.message);
      } else {
        yield GetAccountManagementFailureState(message: "internal_server_error_key".tr(), succes: false);
      }
    } else {
      Utility.showToast(
        msg: "please_check_your_internet_connection_key".tr(),
      );
    }
  }
}
