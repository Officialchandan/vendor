import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/free_coins/bloc/free_coin_history_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/free_coins/bloc/free_coin_history_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class FreeCoinHistoryBloc extends Bloc<FreeCoinHistoryEvent, FreeCoinHistoryState> {
  FreeCoinHistoryBloc() : super(GetFreeCoinHistoryInitialState());

  @override
  Stream<FreeCoinHistoryState> mapEventToState(FreeCoinHistoryEvent event) async* {
    if (event is GetFreeCoinsHistoryEvent) {
      yield* getFreeCoinHistoryApi(event.input);
    }
    if (event is FindUserEvent) {
      yield GetFreeCoinUserSearchState(searchword: event.searchkeyword);
    }
  }

  Stream<FreeCoinHistoryState> getFreeCoinHistoryApi(input) async* {
    if (await Network.isConnected()) {
      NormalLedgerResponse response = await apiProvider.getVendorFreeCoinsHistory(input);
      if (response.success) {
        List<OrderData> orderList = [];
        await Future.forEach(response.data, (OrderData order) async {
          order.orderType = 0;
          orderList.add(order);
        });
        await Future.forEach(response.directBilling, (OrderData order) async {
          order.orderType = 1;
          orderList.add(order);
        });
        orderList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        yield GetFreeCoinHistoryState(data: orderList);
      } else {
        yield GetFreeCoinHistoryFailureState(succes: response.success, message: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}
