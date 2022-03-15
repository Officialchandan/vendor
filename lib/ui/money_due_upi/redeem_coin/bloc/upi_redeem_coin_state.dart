import 'package:equatable/equatable.dart';
import 'package:vendor/ui/money_due_upi/redeem_coin/response/redeem_coin_response.dart';

class RedeemCoinStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class RedeemCoinInitialState extends RedeemCoinStates {}

class RedeemCoinLoadingState extends RedeemCoinStates {}

class GetRedeemCoinState extends RedeemCoinStates {
  GetRedeemCoinState({required this.data});
  final List<CoinDetail> data;
  @override
  List<Object?> get props => [data];
}

class GetSearchDataState extends RedeemCoinStates {
  GetSearchDataState({required this.data});
  final String data;
  @override
  List<Object?> get props => [data];
}

class RedeemCoinFailureState extends RedeemCoinStates {
  RedeemCoinFailureState({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
