import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/bloc/master_ledger_history_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/master_ledger/bloc/master_ledger_history_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class NormalLedgerHistoryBloc extends Bloc<NormalLedgerHistoryEvent, NormalLedgerHistoryState> {
  NormalLedgerHistoryBloc() : super(GetNormalLedgerHistoryInitialState());

  @override
  Stream<NormalLedgerHistoryState> mapEventToState(NormalLedgerHistoryEvent event) async* {
    if (event is GetNormalLedgerHistoryEvent) {
      yield GetNormalLedgerHistoryLoadingState();
      yield* getNormalLedgerHistoryApi(event.input);
    }
    if (event is GetFindUserEvent) {
      yield GetNormalLedgerUserSearchState(searchword: event.searchkeyword);
    }
  }

  Stream<NormalLedgerHistoryState> getNormalLedgerHistoryApi(input) async* {
    log("===>getNormalLedgerHistoryApi");
    if (await Network.isConnected()) {
      NormalLedgerResponse response = await apiProvider.getNormalLedgerHistory(input);
      if (response.success) {
        List<OrderData> orderList = [];

        await Future.forEach(response.directBilling, (OrderData order) async {
          order.orderType = 1;
          orderList.add(order);
        });
        orderList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        yield GetNormalLedgerState(orderList: orderList);
      } else {
        yield GetNormalLedgerHistoryFailureState(succes: response.success, message: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}
