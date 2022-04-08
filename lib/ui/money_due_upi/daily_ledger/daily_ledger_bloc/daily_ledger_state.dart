import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_master_ledger_history.dart';
import 'package:vendor/ui/money_due_upi/normal_ledger/model/normal_ladger_response.dart';

class DailyLedgerHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDailyLedgerHistoryInitialState extends DailyLedgerHistoryState {
  @override
  List<Object?> get props => [];
}

class GetDailyLedgerHistoryState extends DailyLedgerHistoryState {
  final List<CommonLedgerHistory>? data;

  GetDailyLedgerHistoryState({this.data});
  @override
  List<Object?> get props => [data];
}

class GetDailyLedgerState extends DailyLedgerHistoryState {
  final List<OrderData> orderList;

  GetDailyLedgerState({required this.orderList});
  @override
  List<Object?> get props => [orderList];
}

class GetDailyLedgerHistoryLoadingState extends DailyLedgerHistoryState {
  @override
  List<Object?> get props => [];
}

class GetDailyLedgerHistoryFailureState extends DailyLedgerHistoryState {
  final message;
  final succes;
  GetDailyLedgerHistoryFailureState({this.message, this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetDailyLedgerUserSearchState extends DailyLedgerHistoryState {
  final String searchword;
  GetDailyLedgerUserSearchState({required this.searchword});

  @override
  // TODO: implement props
  List<Object?> get props => [searchword];
}
