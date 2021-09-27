import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_purchased_product_response.dart';

class SaleReturnState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SaleReturnInitialState extends SaleReturnState {}

class SaleReturnLoadingState extends SaleReturnState {}

class GetProductSuccessState extends SaleReturnState {
  final List<PurchaseProductModel> purchaseList;

  GetProductSuccessState({required this.purchaseList});

  @override
  List<Object?> get props => [purchaseList];
}

class ProductReturnSuccessState extends SaleReturnState {}

class VerifyOtpSuccessState extends SaleReturnState {}
