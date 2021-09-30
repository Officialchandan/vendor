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
  int index;

  DeleteBillingProductstate(
      {required this.billingItemList, required this.index});

  @override
  List<Object?> get props => [billingItemList, index];
}

class EditBillingProductstate extends BillingProductsState {
  ProductModel billingItemList;
  int index;
  EditBillingProductstate({required this.billingItemList, required this.index});

  @override
  List<Object?> get props => [billingItemList, index];
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
