import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_due_amount_response.dart';

import '../../../../model/Vender_earn_redeem_detail.dart';

class MoneyDueState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MoneyDueInitialState extends MoneyDueState {}

class GetDueAmountLoadingState extends MoneyDueState {
  @override
  List<Object?> get props => [];
}

class GetDueAmountState extends MoneyDueState {
  final GetDueAmountData dueAmount;

  GetDueAmountState({required this.dueAmount});

  @override
  List<Object?> get props => [dueAmount];
}

// ? vendor data earn generate State
class GetVendorEarnGenerateState extends MoneyDueState {
  final VendorDataearnredeem data;
  GetVendorEarnGenerateState({
    required this.data,
  });
  @override
  List<Object?> get props => [data];
}

class GetFreeCoinInitialState extends MoneyDueState {
  @override
  List<Object?> get props => [];
}

class GetFreeCoinState extends MoneyDueState {
  final data;
  GetFreeCoinState({
    this.data,
  });
  @override
  List<Object?> get props => [data];
}

class GetFreeCoinFailureState extends MoneyDueState {
  final message;
  final succes;

  GetFreeCoinFailureState({this.message, this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetFreeCoinLoadingState extends MoneyDueState {
  @override
  List<Object?> get props => [];
}

class GetPaymentTransictionInitialState extends MoneyDueState {
  @override
  List<Object?> get props => [];
}

class GetPaymentTransictionState extends MoneyDueState {
  final signature;
  final txnToken;
  final mid;
  final orderId;
  final callbackUrl;
  GetPaymentTransictionState(
      {this.signature,
      this.txnToken,
      this.mid,
      this.orderId,
      this.callbackUrl});
  @override
  List<Object?> get props => [signature, txnToken, mid, orderId, callbackUrl];
}

class GetPaymentTransictionFailureState extends MoneyDueState {
  final message;
  final succes;

  GetPaymentTransictionFailureState({this.message, this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetPaymentTransictionLoadingState extends MoneyDueState {
  @override
  List<Object?> get props => [];
}
