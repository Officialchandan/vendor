import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/billing_product_response.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_event.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_state.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/utility.dart';

class BillingProductsBloc
    extends Bloc<BillingProductsEvent, BillingProductsState> {
  BillingProductsBloc() : super(IntitalBillingProductstate());
  @override
  Stream<BillingProductsState> mapEventToState(
      BillingProductsEvent event) async* {
    if (event is EditBillingProductsEvent) {
      yield EditBillingProductstate(
          billingItemList: event.billingItemList, index: event.index);
    }

    if (event is DeleteBillingProductsEvent) {
      yield DeleteBillingProductstate(
          billingItemList: event.billingItemList, index: event.index);
    }
    if (event is CheckedBillingProductsEvent) {
      yield CheckerBillingProductstate(check: event.check, index: event.index);
    }

    if (event is TotalPayAmountBillingProductsEvent) {
      yield TotalPayAmountBillingProductsState(mrp: event.mrp);
    }
    if (event is TotalRedeemCoinBillingProductsEvent) {
      yield TotalRedeemCoinBillingProductsState(coin: event.coin);
    }
    if (event is TotalEarnCoinBillingProductsEvent) {
      yield TotalEarnCoinBillingProductsState(coin: event.coin);
    }
    if (event is PayBillingProductsEvent) {
      yield* billingProductApi(event.input);
    }
  }
}

Stream<BillingProductsState> billingProductApi(
    Map<String, dynamic> input) async* {
  if (await Network.isConnected()) {
    EasyLoading.show();
    BillingProductResponse response =
        await apiProvider.getBillingProducts(input);
    EasyLoading.dismiss();
    if (response.success) {
      yield PayBillingProductsState(
          message: response.message,
          data: response.data!,
          succes: response.success);
    } else {
      EasyLoading.dismiss();
      Utility.showToast(response.message);
    }
  } else {
    Utility.showToast("Please check your internet connection");
  }
}
