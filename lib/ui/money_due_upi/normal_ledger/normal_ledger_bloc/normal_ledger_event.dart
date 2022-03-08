import 'package:equatable/equatable.dart';

class NormalLedgerHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetNormalLedgerHistoryEvent extends NormalLedgerHistoryEvent {
  final Map<String, dynamic> input;
  GetNormalLedgerHistoryEvent({required this.input});
  @override
  List<Object?> get props => [];
}
