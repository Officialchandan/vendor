import 'package:equatable/equatable.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';

class FreeCoinHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetFreeCoinHistoryInitialState extends FreeCoinHistoryState {
  @override
  List<Object?> get props => [];
}

class GetFreeCoinHistoryState extends FreeCoinHistoryState {
  final List<OrderData>? data;
  GetFreeCoinHistoryState({this.data});
  @override
  List<Object?> get props => [data];
}

class GetFreeCoinHistoryLoadingState extends FreeCoinHistoryState {
  @override
  List<Object?> get props => [];
}

class GetFreeCoinHistoryFailureState extends FreeCoinHistoryState {
  final message;
  final succes;
  GetFreeCoinHistoryFailureState({this.message, this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetFreeCoinUserSearchState extends FreeCoinHistoryState {
  final String searchword;
  GetFreeCoinUserSearchState({required this.searchword});

  @override
  // TODO: implement props
  List<Object?> get props => [searchword];
}
