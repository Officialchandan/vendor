import 'package:equatable/equatable.dart';
import 'package:vendor/model/billing_product_response.dart';
import 'package:vendor/model/product_model.dart';

class BillingProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditBillingProductsEvent extends BillingProductsEvent {
  ProductModel billingItemList;
  int index;
  EditBillingProductsEvent(
      {required this.billingItemList, required this.index});
  @override
  List<Object?> get props => [billingItemList, index];
}

class DeleteBillingProductsEvent extends BillingProductsEvent {
  ProductModel billingItemList;
  int index;
  DeleteBillingProductsEvent(
      {required this.billingItemList, required this.index});
  @override
  List<Object?> get props => [billingItemList, index];
}

class CheckedBillingProductsEvent extends BillingProductsEvent {
  final bool check;
  final int index;
  CheckedBillingProductsEvent({required this.check, required this.index});
  @override
  List<Object?> get props => [check, index];
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
