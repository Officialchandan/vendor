import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_due_amount_response.dart';
import 'package:vendor/model/get_vendor_free_coin.dart';
import 'package:vendor/model/payment/initiate_payment_response.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_event.dart';
import 'package:vendor/ui_without_inventory/performancetracker/upi/bloc/due_amount_state.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class MoneyDueBloc extends Bloc<MoneyDueEvent, MoneyDueState> {
  MoneyDueBloc() : super(MoneyDueInitialState());

  @override
  Stream<MoneyDueState> mapEventToState(MoneyDueEvent event) async* {
    if (event is GetDueAmount) {
      yield* getDueAmountApi();
    }
    if (event is GetFreeCoins) {
      yield* getFreeCoinApi();
    }
    if (event is GetInitiateTransiction) {
      yield* getInitatePaymentApi(event.input);
    }
  }

  Stream<MoneyDueState> getDueAmountApi() async* {
    if (await Network.isConnected()) {
      GetDueAmountResponse response = await apiProvider.getDueAmount();
      yield GetDueAmountState(dueAmount: response.totalDue, categoryDue: response.data);
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<MoneyDueState> getFreeCoinApi() async* {
    if (await Network.isConnected()) {
      GetVendorFreeCoinResponse response = await apiProvider.getVendorFreeCoins();
      if (response.success) {
        yield GetFreeCoinState(data: response.data);
      } else {
        yield GetFreeCoinFailureState(
          message: response.message,
          succes: response.success,
        );
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<MoneyDueState> getInitatePaymentApi(input) async* {
    if (await Network.isConnected()) {
      IntiatePaymnetResponse response = await apiProvider.initiatePayment(input);
      if (response.success) {
        yield GetPaymentTransictionState(
            txnToken: response.txnToken, signature: response.signature, mid: response.mid, orderId: response.orderId);
      } else {
        yield GetPaymentTransictionFailureState(
          message: response.message,
          succes: response.success,
        );
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }
}
