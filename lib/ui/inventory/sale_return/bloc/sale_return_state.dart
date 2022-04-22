import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_purchased_product_response.dart';
import 'package:vendor/model/sale_return_resonse.dart';

class SaleReturnState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SaleReturnInitialState extends SaleReturnState {}

class SaleReturnLoadingState extends SaleReturnState {}

class GetProductSuccessState extends SaleReturnState {
  final List<SaleReturnProducts> purchaseList;

  GetProductSuccessState({required this.purchaseList});

  @override
  List<Object?> get props => [purchaseList];
}

class GetProductFailureState extends SaleReturnState {
  final String message;

  GetProductFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductReturnSuccessState extends SaleReturnState {
  final message;
  final Map input;
  final SaleReturnData data;

  ProductReturnSuccessState({this.message, required this.input, required this.data});

  @override
  List<Object?> get props => [message, input];
}

class VerifyOtpSuccessState extends SaleReturnState {
  final message;

  VerifyOtpSuccessState({this.message});

  @override
  List<Object?> get props => [message];
}

class SelectProductState extends SaleReturnState {
  final List<PurchaseProductModel> returnProductList;

  SelectProductState({required this.returnProductList});

  @override
  List<Object?> get props => [returnProductList];
}

class SaleReturnCheckBoxState extends SaleReturnState {
  final bool isChecked;
  final int index;

  SaleReturnCheckBoxState({required this.isChecked, required this.index});

  @override
  List<Object?> get props => [isChecked, index];
}

class SaleReturnQtyIncrementState extends SaleReturnState {
  final int count;
  final int index;

  SaleReturnQtyIncrementState({required this.count, required this.index});

  @override
  List<Object?> get props => [count, index];
}

class SaleReturnQtyDecrementState extends SaleReturnState {
  final int count;
  final int index;

  SaleReturnQtyDecrementState({required this.count, required this.index});

  @override
  List<Object?> get props => [count, index];
}

class SaleReturnClearDataState extends SaleReturnState {
  final String message;

  SaleReturnClearDataState({required this.message});

  @override
  List<Object?> get props => [message];
}
