import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/upi_transfer_detail_ledger_response.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

import 'upi_transfer_detail_ledger_event.dart';
import 'upi_transfer_detail_ledger_state.dart';

class UpiTansferHistoryDeatilLedgerBloc
    extends Bloc<UpiTansferHistoryDeatilLedgerEvent, UpiTansferHistoryDeatilLedgerState> {
  UpiTansferHistoryDeatilLedgerBloc() : super(GetUpiTansferHistoryDeatilLedgerInitialState());

  @override
  Stream<UpiTansferHistoryDeatilLedgerState> mapEventToState(UpiTansferHistoryDeatilLedgerEvent event) async* {
    if (event is GetUpiTansferHistoryDeatilLedgerEvent) {
      yield GetUpiTansferHistoryDeatilLedgerLoadingState();
      yield* getUpiTansferHistoryDeatilLedgerApi(event.input);
    }

    if (event is GetUpiTansferSalereturnHistoryEvent) {
      yield GetUpiTansferSalereturnLoadingState();
      yield* getSaleReturn(event.input);
    }
  }

  Stream<UpiTansferHistoryDeatilLedgerState> getUpiTansferHistoryDeatilLedgerApi(input) async* {
    if (await Network.isConnected()) {
      log("=====>");
      UpiHistroyOrdersLedgerResponse response = await apiProvider.upiPaymentHistoryDetailLedger(input);
      if (response.success) {
        List<UpiHistroyOrdersLedgerData> orderList = [];
        orderList = response.data!;
        orderList.sort((a, b) => b.date.compareTo(a.date));
        // log(orderList);
        yield GetUpiTansferHistoryDeatilLedgerState(data: orderList);
      } else {
        yield GetUpiTansferHistoryDeatilLedgerFailureState(succes: response.success, message: response.message);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<UpiTansferHistoryDeatilLedgerState> getSaleReturn(input) async* {
    if (await Network.isConnected()) {
      UpiSalesReturnResponse response = await apiProvider.upiSalesReturn(input);
      if (response.success) {
        List<BillingDetails> billingDetails = [];
        await Future.forEach(response.data, (BillingDetails detail) {
          billingDetails.add(detail);
        });

        log("Length >>>> " + billingDetails.length.toString());
        log("Length >>>> " + billingDetails[0].orderDetails.length.toString());
        yield GetUpiTansferSalereturnState(response: billingDetails);
      } else {
        yield GetUpiTansferSalereturnFailureState(message: response.message);
      }
    } else {
      yield GetUpiTansferSalereturnFailureState(message: Constant.INTERNET_ALERT_MSG);
    }
  }
}
