import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/main.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/bloc/upi_redeem_coin_event.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/bloc/upi_redeem_coin_state.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/response/redeem_coin_response.dart';
import 'package:vendor/utility/constant.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class RedeemCoinBloc extends Bloc<RedeemCoinEvents, RedeemCoinStates> {
  RedeemCoinBloc() : super(RedeemCoinInitialState());
  @override
  Stream<RedeemCoinStates> mapEventToState(RedeemCoinEvents event) async* {
    if (event is GetRedeemCoinDataEvent) {
      yield RedeemCoinLoadingState();
      yield* getRedeemCoinData(event);
    }
  }

  Stream<RedeemCoinStates> getRedeemCoinData(
      GetRedeemCoinDataEvent event) async* {
    if (await Network.isConnected()) {
      UpiRedeemCoinResponse response =
          await apiProvider.upiRedeemCoin(event.input);

      if (response.success) {
        List<CoinDetail> orderList = [];

        await Future.forEach(response.normalBilling, (CoinDetail detail) {
          detail.billingType = 0;

          if (detail.orderDetails.isNotEmpty) {
            detail.image = detail.orderDetails.first.productImage;
          }
          if (detail.orderDetails.isNotEmpty) {
            detail.productName = detail.orderDetails.first.productName;
          }
          orderList.add(detail);
        });

        await Future.forEach(response.directBilling, (CoinDetail detail) {
          if (detail.billingDetails.isNotEmpty) {
            detail.image = detail.billingDetails.first.categoryImage;
          }

          if (detail.billingDetails.isNotEmpty) {
            detail.productName = detail.billingDetails.first.categoryName;
          }
          detail.billingType = 1;
          orderList.add(detail);
        });

        yield GetRedeemCoinState(data: orderList);
      } else {
        yield RedeemCoinFailureState(message: response.message);
      }
    } else {
      Utility.showToast(Constant.INTERNET_ALERT_MSG);
    }
  }
}