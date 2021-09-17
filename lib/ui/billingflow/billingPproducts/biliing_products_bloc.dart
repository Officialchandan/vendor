import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/ui/billingflow/billingPproducts/biliing_products_event.dart';
import 'package:vendor/ui/billingflow/billingPproducts/biliing_products_state.dart';

class BillingProductsBloc
    extends Bloc<BillingProductsEvent, BillingProductsState> {
  BillingProductsBloc() : super(EditBillingProductstate());
  @override
  Stream<BillingProductsState> mapEventToState(
      BillingProductsEvent event) async* {
    if (event is EditBillingProductsEvent) {}
    if (event is DeleteBillingProductsEvent) {
      yield DeleteBillingProductstate(billingItemList: event.billingItemList);
    }
    if (event is CheckedBillingProductsEvent) {
      yield CheckerBillingProductstate(check: event.check, index: event.index);
    }
  }
}
