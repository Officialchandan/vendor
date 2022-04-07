import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/upi_transfer_history.dart';
import 'package:vendor/ui/money_due_upi/upi_transfer/upi_transfer_bloc/upi_transfer_event.dart';
import 'package:vendor/ui/money_due_upi/upi_transfer/upi_transfer_bloc/upi_transfer_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class UpiTansferHistoryBloc extends Bloc<UpiTansferHistoryEvent, UpiTansferHistoryState> {
  UpiTansferHistoryBloc() : super(GetUpiTansferHistoryInitialState());

  @override
  Stream<UpiTansferHistoryState> mapEventToState(UpiTansferHistoryEvent event) async* {
    if (event is GetUpiTansferHistoryEvent) {
      yield* getUpiTansferHistoryApi();
    }
    if (event is FindUserEvent) {
      yield GetFreeCoinUserSearchState(searchword: event.searchkeyword);
    }
  }

  Stream<UpiTansferHistoryState> getUpiTansferHistoryApi() async* {
    if (await Network.isConnected()) {
      log("=====>");
      UpiTansferResponse response = await apiProvider.upiPaymentHistory();
      if (response.success) {
        List<UpiTansferData> orderList = [];

        orderList.sort((a, b) => b.txnDate.compareTo(a.txnDate));
        yield GetUpiTansferHistoryState(data: orderList);
      } else {
        yield GetUpiTansferHistoryFailureState(succes: response.success, message: response.message);
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }
}
