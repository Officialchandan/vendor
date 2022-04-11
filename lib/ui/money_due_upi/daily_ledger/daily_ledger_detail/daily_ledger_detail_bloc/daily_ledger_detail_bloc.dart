import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/money_due_upi/daily_ledger/daily_ledger_detail/daily_ledger_detail_bloc/daily_ledger_detail_event.dart';
import 'package:vendor/ui/money_due_upi/daily_ledger/daily_ledger_detail/daily_ledger_detail_bloc/daily_ledger_detail_state.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';

class DailyLedgerDetailBloc extends Bloc<DailyLedgerDetailEvents, DailyLedgerDetailStates> {
  DailyLedgerDetailBloc() : super(DailyLedgerDetailInitialState());
  @override
  Stream<DailyLedgerDetailStates> mapEventToState(DailyLedgerDetailEvents event) async* {
    if (event is GetDailyLedgerDetailHistoryEvent) {
      yield DailyLedgerDetailLoadingState();
      yield* getSaleReturn(event);
    }
  }

  Stream<DailyLedgerDetailStates> getSaleReturn(GetDailyLedgerDetailHistoryEvent event) async* {
    if (await Network.isConnected()) {
      UpiSalesReturnResponse response = await apiProvider.upiSalesReturn(event.input);
      if (response.success) {
        List<BillingDetails> billingDetails = [];
        await Future.forEach(response.data, (BillingDetails detail) {
          billingDetails.add(detail);
        });

        log("Length >>>> " + billingDetails.length.toString());
        log("Length >>>> " + billingDetails[0].orderDetails.length.toString());
        yield DailyLedgerDetailHistoryState(response: billingDetails);
      } else {
        yield DailyLedgerDetailFailureState(message: response.message);
      }
    } else {
      yield DailyLedgerDetailFailureState(message: Constant.INTERNET_ALERT_MSG);
    }
  }
}
