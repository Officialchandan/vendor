import 'package:equatable/equatable.dart';

class DailyLedgerDetailEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDailyLedgerDetailHistoryEvent extends DailyLedgerDetailEvents {
  final Map<String, dynamic> input;
  GetDailyLedgerDetailHistoryEvent({required this.input});
  @override
  List<Object?> get props => [input];
}
