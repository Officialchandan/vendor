import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_purchased_product_response.dart';

class SaleReturnEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPurchasedProductEvent extends SaleReturnEvent {
  final String mobile;

  GetPurchasedProductEvent({required this.mobile});

  @override
  List<Object?> get props => [mobile];
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
