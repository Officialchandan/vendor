import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_master_ledger_history.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';

class NormalLedgerHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetNormalLedgerHistoryInitialState extends NormalLedgerHistoryState {
  @override
  List<Object?> get props => [];
}

class GetNormalLedgerHistoryState extends NormalLedgerHistoryState {
  final List<CommonLedgerHistory>? data;

  GetNormalLedgerHistoryState({this.data});
  @override
  List<Object?> get props => [data];
}

class GetNormalLedgerState extends NormalLedgerHistoryState {
  final List<OrderData> orderList;

  GetNormalLedgerState({required this.orderList});
  @override
  List<Object?> get props => [orderList];
}

class GetNormalLedgerHistoryLoadingState extends NormalLedgerHistoryState {
  @override
  List<Object?> get props => [];
}

class GetNormalLedgerHistoryFailureState extends NormalLedgerHistoryState {
  final message;
  final succes;
  GetNormalLedgerHistoryFailureState({this.message, this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetNormalLedgerUserSearchState extends NormalLedgerHistoryState {
  final String searchword;
  GetNormalLedgerUserSearchState({required this.searchword});

  @override
  // TODO: implement props
  List<Object?> get props => [searchword];
}
