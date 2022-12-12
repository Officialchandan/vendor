import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:vendor/utility/network.dart';

import '../../../../main.dart';
import '../../../../model/getdue_amount_by_day.dart';
import '../../../../utility/sharedpref.dart';
import '../../../../utility/utility.dart';
import 'billing_option_bloc_event.dart';
import 'billing_option_bloc_state.dart';

class BillingOptionBlocBloc
    extends Bloc<BillingOptionBlocEvent, BillingOptionBlocState> {
  BillingOptionBlocBloc() : super(BillingOptionBlocInitial()) {
    on<BillingOptionBlocEvent>((event, emit) async* {
      if (event is GetBillingDueAmmountEvent) {
        yield* getDueAmountResponse();
      }
    });
  }
  Stream<BillingOptionBlocState> getDueAmountResponse() async* {
    if (await Network.isConnected()) {
      try {
        GetDueAmountByDay result = await apiProvider.getDueAmountByVendorId();
        log("$result");
        if (result.success) {
          /// please remove =

          if (result.data!.totalDue! - result.data!.todayDue! >= 0) {
            print("done");
            await SharedPref.setBooleanPreference("isDueAmount", true);
            yield getBillingOptionsDueAmoutResponseState(
                message: result.message,
                data: result.data!,
                status: result.success);
          } else {
            await SharedPref.setBooleanPreference("isDueAmount", false);
          }
        } else {
          print("ok");
          // yield GetDirectBillingCategoryByVendorIdFailureState(
          //     message: result.message);
        }
      } catch (error) {
        print(error);
        // yield GetDirectBillingCategoryByVendorIdFailureState(
        //     message: "internal_server_error_key".tr());
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }
}
