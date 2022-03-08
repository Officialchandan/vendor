import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_master_ledger_history.dart';

class NormalLedgerHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetNormalLedgerHistoryInitialState extends NormalLedgerHistoryState {
  @override
  List<Object?> get props => [];
}

class GetNormalLedgerHistoryState extends NormalLedgerHistoryState {
  final List<GetNormalLedgerHistoryData>? data;

  final List<GetNormalLedgerHistoryDirectBilling>? directdata;
  GetNormalLedgerHistoryState({this.data, this.directdata});
  @override
  List<Object?> get props => [data, directdata];
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
