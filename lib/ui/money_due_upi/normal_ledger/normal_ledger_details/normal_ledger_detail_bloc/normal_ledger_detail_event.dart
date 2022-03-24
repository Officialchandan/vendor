import 'package:equatable/equatable.dart';

class NormalLedgerDetailEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetNormalLedgerDetailHistoryEvent extends NormalLedgerDetailEvents {
  final Map<String, dynamic> input;
  GetNormalLedgerDetailHistoryEvent({required this.input});
  @override
  List<Object?> get props => [input];
}
