import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_event.dart';
import 'package:vendor/ui/billingflow/billingproducts/biliing_products_state.dart';

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
  }
}
