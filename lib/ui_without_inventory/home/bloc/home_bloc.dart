import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:vendor/model/getdue_amount_by_day.dart';
import '../../../main.dart';
import '../../../utility/network.dart';
import '../../../utility/sharedpref.dart';
import '../../../utility/utility.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState());
  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetDueAmmountEvent) {
      print("------->");
      yield* getDueAmountResponse();
    }
  }

  Stream<HomeState> getDueAmountResponse() async* {
    if (await Network.isConnected()) {
      try {
        GetDueAmountByDay result = await apiProvider.getDueAmountByVendorId();
        log("$result");
        if (result.success) {
          // var now = DateTime.now();
          // var initalizetime = new DateFormat('yyyy-MM-dd HH:mm:ss').parse(
          //     '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} 12:50:00');
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
            // print("done");
            await SharedPref.setBooleanPreference("isDueAmount", true);
            yield GetChatPapdiDueAmoutResponseSuccessState(
                message: result.message,
                data: result.data!,
                status: result.success);
          } else {
            await SharedPref.setBooleanPreference("isDueAmount", false);
          }
        } else {
          yield GetFailureState(message: result.message);
        }
      } catch (error) {
        yield GetFailureState(message: "internal_server_error_key".tr());
      }
    } else {
      Utility.showToast(msg: "please_check_your_internet_connection_key".tr());
    }
  }
}
