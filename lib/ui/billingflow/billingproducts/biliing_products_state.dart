import 'package:equatable/equatable.dart';
import 'package:vendor/model/product_model.dart';

abstract class BillingProductsState extends Equatable {}

class CheckerBillingProductstate extends BillingProductsState {
  List<ProductModel> productList;
  bool isChecked;
  CheckerBillingProductstate(
      {required this.productList, required this.isChecked});

  @override
  List<Object?> get props => [productList, isChecked];
}

class BillingProductLoadingState extends BillingProductsState {
  @override
  List<Object?> get props => [];
}

class DeleteBillingProductState extends BillingProductsState {
  final int index;

  DeleteBillingProductState({required this.index});

  @override
  List<Object?> get props => [index];
}

class EditBillingProductState extends BillingProductsState {
  final double price;
  final int index;
  final double earningCoin;

  EditBillingProductState(
      {required this.price, required this.index, required this.earningCoin});

  @override
  List<Object?> get props => [price, index, earningCoin];
}

class IntitalBillingProductstate extends BillingProductsState {
  IntitalBillingProductstate();

  @override
  List<Object?> get props => [];
}

class TotalPayAmountBillingProductsState extends BillingProductsState {
  final double mrp;

  TotalPayAmountBillingProductsState({required this.mrp});

  @override
  List<Object> get props => [mrp];
}

class TotalRedeemCoinBillingProductsState extends BillingProductsState {
  final double coin;

  TotalRedeemCoinBillingProductsState({required this.coin});

  @override
  List<Object> get props => [coin];
}

class TotalEarnCoinBillingProductsState extends BillingProductsState {
  final double coin;

  TotalEarnCoinBillingProductsState({required this.coin});

  @override
  List<Object> get props => [coin];
}

class PayBillingProductsState extends BillingProductsState {
  final message;
  final data;
  final succes;

  PayBillingProductsState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class OtpResendBillingProductState extends BillingProductsState {
  final message;
  final data;
  final succes;

  OtpResendBillingProductState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class PayBillingProductsStateLoadingstate extends BillingProductsState {
  // final String message;
  // GetCustomerNumberResponseLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class PayBillingProductsStateFailureState extends BillingProductsState {
  final String message;
  final succes;

  PayBillingProductsStateFailureState(
      {required this.message, required this.succes});

  @override
  List<Object?> get props => [message, succes];
}

class VerifyOtpState extends BillingProductsState {
  final message;
  final data;
  final succes;

  VerifyOtpState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class VerifyOtpStateLoadingstate extends BillingProductsState {
  // final String message;
  // GetCustomerNumberResponseLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class VerifyOtpStateFailureState extends BillingProductsState {
  final String message;
  final succes;

  VerifyOtpStateFailureState({required this.message, required this.succes});

  @override
  List<Object?> get props => [message, succes];
}
