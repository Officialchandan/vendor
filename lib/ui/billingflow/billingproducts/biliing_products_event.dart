import 'package:equatable/equatable.dart';
import 'package:vendor/model/product_model.dart';

class BillingProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditBillingProductsEvent extends BillingProductsEvent {
  final int index;
  final double price;
  final double earningCoin;

  EditBillingProductsEvent(
      {required this.price, required this.earningCoin, required this.index});

  @override
  List<Object?> get props => [price, index];
}

class DeleteBillingProductsEvent extends BillingProductsEvent {
  final int index;

  DeleteBillingProductsEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class CheckedBillingProductsEvent extends BillingProductsEvent {
 List<ProductModel> productList;
bool isChecked;
  CheckedBillingProductsEvent({required this.productList, required this.isChecked});

  @override
  List<Object?> get props => [productList, isChecked];
}

class TotalPayAmountBillingProductsEvent extends BillingProductsEvent {
  final double mrp;

  TotalPayAmountBillingProductsEvent({required this.mrp});

  @override
  List<Object> get props => [
        mrp,
      ];
}

class TotalRedeemCoinBillingProductsEvent extends BillingProductsEvent {
  final double coin;

  TotalRedeemCoinBillingProductsEvent({required this.coin});

  @override
  List<Object> get props => [coin];
}

class TotalEarnCoinBillingProductsEvent extends BillingProductsEvent {
  final double coin;

  TotalEarnCoinBillingProductsEvent({required this.coin});

  @override
  List<Object> get props => [coin];
}

class PayBillingProductsEvent extends BillingProductsEvent {
  final Map<String, dynamic> input;

  PayBillingProductsEvent({required this.input});

  @override
  List<Object> get props => [input];
}

class OtpVerifyEvent extends BillingProductsEvent {
  final Map<String, dynamic> input;

  OtpVerifyEvent({required this.input});

  @override
  List<Object> get props => [input];
}
