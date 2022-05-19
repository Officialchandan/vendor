import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/daily_ledger_withoutinventory/daily_ledger_bloc/daily_ledger_withoutinventory_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/daily_ledger_withoutinventory/daily_ledger_bloc/daily_ledger_withoutinventory_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class DailyLedgerHistoryBloc extends Bloc<DailyLedgerHistoryEvent, DailyLedgerHistoryState> {
  DailyLedgerHistoryBloc() : super(GetDailyLedgerHistoryInitialState());

  @override
  Stream<DailyLedgerHistoryState> mapEventToState(DailyLedgerHistoryEvent event) async* {
    if (event is GetDailyLedgerHistoryEvent) {
      yield* getDailyLedgerHistoryApi(event.input);
    }
    if (event is GetFindUserEvent) {
      yield GetDailyLedgerUserSearchState(searchword: event.searchkeyword);
    }
  }

  Stream<DailyLedgerHistoryState> getDailyLedgerHistoryApi(input) async* {
    log("===>getDailyLedgerHistoryApi$input");
    if (await Network.isConnected()) {
      NormalLedgerResponse response = await apiProvider.getNormalLedgerHistory(input);
      if (response.success) {
        List<OrderData> orderList = [];
        // orderList.addAll(response.data);
        // orderList.addAll(response.directBilling);

        await Future.forEach(response.directBilling, (OrderData order) async {
          order.orderType = 1;
          orderList.add(order);
        });
        orderList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        yield GetDailyLedgerState(orderList: orderList);

        // yield GetNormalLedgerHistoryState(data: products);
      } else {
        yield GetDailyLedgerHistoryFailureState(succes: response.success, message: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}
