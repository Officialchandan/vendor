import 'package:equatable/equatable.dart';

class DailyLedgerHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDailyLedgerHistoryEvent extends DailyLedgerHistoryEvent {
  final Map<String, dynamic> input;
  GetDailyLedgerHistoryEvent({required this.input});
  @override
  List<Object?> get props => [];
}

class GetFindUserEvent extends DailyLedgerHistoryEvent {
  final searchkeyword;

  GetFindUserEvent({required this.searchkeyword});
  List<Object?> get props => [searchkeyword];
}
