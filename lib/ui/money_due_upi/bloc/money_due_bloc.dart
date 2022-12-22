import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_due_amount_response.dart';
import 'package:vendor/model/payment/initiate_payment_response.dart';
import 'package:vendor/ui/money_due_upi/bloc/money_due_event.dart';
import 'package:vendor/ui/money_due_upi/bloc/money_due_state.dart';

import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

import '../../../model/Vender_earn_redeem_detail.dart';
import '../../../model/get_vendor_free_coin.dart';

class MoneyDueBloc extends Bloc<MoneyDueEvent, MoneyDueState> {
  MoneyDueBloc() : super(MoneyDueInitialState());

  @override
  Stream<MoneyDueState> mapEventToState(MoneyDueEvent event) async* {
    if (event is GetFreeCoins) {
      yield* getFreeCoinApi();
    }

    if (event is GetDueAmount) {
      yield* getDueAmountApi();
    }

    if (event is GetInitiateTransiction) {
      yield* getInitatePaymentApi(event.input);
    }
    if (event is GetredeemEarnDataEvent) {
      yield* getVendorEarnRedeemDataApi();
    }
  }

  Stream<MoneyDueState> getDueAmountApi() async* {
    if (await Network.isConnected()) {
      GetDueAmountResponse response = await apiProvider.getDueAmount();

      if (response.success) {
        yield GetDueAmountState(
          dueAmount: response.data!,
        );
        add(GetredeemEarnDataEvent());
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<MoneyDueState> getVendorEarnRedeemDataApi() async* {
    if (await Network.isConnected()) {
      Getvendorearnredeemdetail response =
          await apiProvider.getVendorEarnRedeemAmount();
      if (response.success) {
        yield GetVendorEarnGenerateState(data: response.data!);
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<MoneyDueState> getFreeCoinApi() async* {
    yield GetFreeCoinLoadingState();
    if (await Network.isConnected()) {
      GetVendorFreeCoinResponse response =
          await apiProvider.getVendorFreeCoins();
      if (response.success) {
        EasyLoading.dismiss();
        yield GetFreeCoinState(data: response.data);
      } else {
        EasyLoading.dismiss();
        yield GetFreeCoinFailureState(
          message: response.message,
          succes: response.success,
        );
      }
    } else {
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }

  Stream<MoneyDueState> getInitatePaymentApi(input) async* {
    if (await Network.isConnected()) {
      IntiatePaymnetResponse response =
          await apiProvider.initiatePayment(input);
      if (response.success) {
        EasyLoading.dismiss();
        yield GetPaymentTransictionState(
            txnToken: response.txnToken,
            signature: response.signature,
            mid: response.mid,
            orderId: response.orderId,
            callbackUrl: response.callbackUrl);
      } else {
        EasyLoading.dismiss();
        yield GetPaymentTransictionFailureState(
          message: response.message,
          succes: response.success,
        );
      }
    } else {
      EasyLoading.dismiss();
      Utility.showToast(msg: Constant.INTERNET_ALERT_MSG);
    }
  }
}
