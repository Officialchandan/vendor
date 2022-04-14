import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_purchased_product_response.dart';

class SaleReturnEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPurchasedProductEvent extends SaleReturnEvent {
  final Map input;

  GetPurchasedProductEvent({required this.input});

  @override
  List<Object?> get props => [input];
}

class SaleReturnApiEvent extends SaleReturnEvent {
  final Map input;

  SaleReturnApiEvent({required this.input});

  @override
  List<Object?> get props => [input];
}

class VerifyOtpEvent extends SaleReturnEvent {
  final Map input;

  VerifyOtpEvent({required this.input});

  @override
  List<Object?> get props => [input];
}

class SelectProductEvent extends SaleReturnEvent {
  final List<PurchaseProductModel> returnProductList;

  SelectProductEvent({required this.returnProductList});

  @override
  List<Object?> get props => [returnProductList];
}

class SaleReturnCheckBoxEvent extends SaleReturnEvent {
  final bool isChecked;
  final int index;

  SaleReturnCheckBoxEvent({required this.isChecked, required this.index});

  @override
  List<Object?> get props => [isChecked, index];
}

class SaleReturnQtyIncrementEvent extends SaleReturnEvent {
  final int count;
  final int index;

  SaleReturnQtyIncrementEvent({required this.count, required this.index});

  @override
  List<Object?> get props => [count, index];
}

class SaleReturnQtyDecrementEvent extends SaleReturnEvent {
  final int count;
  final int index;

  SaleReturnQtyDecrementEvent({required this.count, required this.index});

  @override
  List<Object?> get props => [count, index];
}

class SaleReturnClearDataEvent extends SaleReturnEvent {
 final String message;
  SaleReturnClearDataEvent({required this.message});
  @override
  List<Object?> get props => [message];
}
