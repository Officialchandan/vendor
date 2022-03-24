import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_details/normal_ledger_detail_bloc/normal_ledger_detail_event.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/normal_ledger_details/normal_ledger_detail_bloc/normal_ledger_detail_state.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';

class NormalLedgerDetailBloc extends Bloc<NormalLedgerDetailEvents, NormalLedgerDetailStates> {
  NormalLedgerDetailBloc() : super(NormalLedgerDetailInitialState());
  @override
  Stream<NormalLedgerDetailStates> mapEventToState(NormalLedgerDetailEvents event) async* {
    if (event is GetNormalLedgerDetailHistoryEvent) {
      yield NormalLedgerDetailLoadingState();
      yield* getSaleReturn(event);
    }
  }

  Stream<NormalLedgerDetailStates> getSaleReturn(GetNormalLedgerDetailHistoryEvent event) async* {
    if (await Network.isConnected()) {
      UpiSalesReturnResponse response = await apiProvider.upiSalesReturn(event.input);
      if (response.success) {
        List<BillingDetails> billingDetails = [];
        await Future.forEach(response.data, (BillingDetails detail) {
          billingDetails.add(detail);
        });

        log("Length >>>> " + billingDetails.length.toString());
        yield NormalLedgerDetailHistoryState(response: billingDetails);
      } else {
        yield NormalLedgerDetailFailureState(message: response.message);
      }
    } else {
      yield NormalLedgerDetailFailureState(message: Constant.INTERNET_ALERT_MSG);
    }
  }
}
