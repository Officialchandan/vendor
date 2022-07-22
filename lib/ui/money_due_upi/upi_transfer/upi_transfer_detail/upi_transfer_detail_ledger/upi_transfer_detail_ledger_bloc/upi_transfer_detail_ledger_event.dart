import 'package:equatable/equatable.dart';

class UpiTansferHistoryDeatilLedgerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryDeatilLedgerEvent extends UpiTansferHistoryDeatilLedgerEvent {
  final Map<String, dynamic> input;
  GetUpiTansferHistoryDeatilLedgerEvent({required this.input});
  @override
  List<Object?> get props => [];
}

class GetUpiTansferSalereturnHistoryEvent extends UpiTansferHistoryDeatilLedgerEvent {
  final Map<String, dynamic> input;
  GetUpiTansferSalereturnHistoryEvent({required this.input});
  @override
  List<Object?> get props => [input];
}
