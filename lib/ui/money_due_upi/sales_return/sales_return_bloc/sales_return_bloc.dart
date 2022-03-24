import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_return_bloc/sales_return_events.dart';
import 'package:vendor/ui/money_due_upi/sales_return/sales_return_bloc/sales_return_states.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';

class SalesReturnBloc extends Bloc<SalesReturnEvents, SalesReturnStates> {
  SalesReturnBloc() : super(SalesReturnInitialState());
  @override
  Stream<SalesReturnStates> mapEventToState(SalesReturnEvents event) async* {
    if (event is GetSalesReturnHistoryEvent) {
      yield SalesReturnLoadingState();
      yield* getSaleReturn(event);
    }
    if (event is GetSalesReturnDataSearchEvent) {
      yield SalesReturnDataSearchState(keyWord: event.keyWord);
    }
  }

  Stream<SalesReturnStates> getSaleReturn(
      GetSalesReturnHistoryEvent event) async* {
    if (await Network.isConnected()) {
      UpiSalesReturnResponse response =
          await apiProvider.upiSalesReturn(event.input);
      if (response.success) {
        List<BillingDetails> billingDetails = [];
        await Future.forEach(response.data, (BillingDetails detail) {
          detail.billingType = 0;
          billingDetails.add(detail);
        });

        await Future.forEach(response.directBilling, (BillingDetails detail) {
          detail.billingType = 1;
          billingDetails.add(detail);
        });
        log("Length >>>> " + billingDetails.length.toString());
        yield SalesReturnHistoryState(response: billingDetails);
      } else {
        yield SalesReturnFailureState(message: response.message);
      }
    } else {
      yield SalesReturnFailureState(message: Constant.INTERNET_ALERT_MSG);
    }
  }
}
