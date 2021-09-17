import 'package:equatable/equatable.dart';
import 'package:vendor/model/product_model.dart';

abstract class BillingProductsState extends Equatable {}

class CheckerBillingProductstate extends BillingProductsState {
  final bool check;
  final int index;
  CheckerBillingProductstate({required this.check, required this.index});

  @override
  List<Object?> get props => [check, index];
}

class DeleteBillingProductstate extends BillingProductsState {
  ProductModel billingItemList;

  DeleteBillingProductstate({required this.billingItemList});

  @override
  List<Object?> get props => [billingItemList];
}

class EditBillingProductstate extends BillingProductsState {
  EditBillingProductstate();

  @override
  List<Object?> get props => [];
}
