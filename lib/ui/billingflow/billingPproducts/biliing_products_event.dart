import 'package:equatable/equatable.dart';
import 'package:vendor/model/product_model.dart';

class BillingProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditBillingProductsEvent extends BillingProductsEvent {
  @override
  List<Object?> get props => [];
}

class DeleteBillingProductsEvent extends BillingProductsEvent {
  ProductModel billingItemList;
  DeleteBillingProductsEvent({required this.billingItemList});
  @override
  List<Object?> get props => [billingItemList];
}

class CheckedBillingProductsEvent extends BillingProductsEvent {
  final bool check;
  final int index;
  CheckedBillingProductsEvent({required this.check, required this.index});
  @override
  List<Object?> get props => [check, index];
}
