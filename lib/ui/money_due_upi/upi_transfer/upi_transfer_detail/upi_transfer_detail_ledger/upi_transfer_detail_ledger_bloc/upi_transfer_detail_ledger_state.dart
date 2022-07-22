import 'package:equatable/equatable.dart';
import 'package:vendor/model/upi_transfer_detail_ledger_response.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';

class UpiTansferHistoryDeatilLedgerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryDeatilLedgerInitialState extends UpiTansferHistoryDeatilLedgerState {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryDeatilLedgerState extends UpiTansferHistoryDeatilLedgerState {
  final List<UpiHistroyOrdersLedgerData>? data;
  GetUpiTansferHistoryDeatilLedgerState({this.data});
  @override
  List<Object?> get props => [data];
}

class GetUpiTansferHistoryDeatilLedgerLoadingState extends UpiTansferHistoryDeatilLedgerState {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryDeatilLedgerFailureState extends UpiTansferHistoryDeatilLedgerState {
  final message;
  final succes;
  GetUpiTansferHistoryDeatilLedgerFailureState({this.message, this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetUpiTansferSalereturnInitialState extends UpiTansferHistoryDeatilLedgerState {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferSalereturnLoadingState extends UpiTansferHistoryDeatilLedgerState {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferSalereturnState extends UpiTansferHistoryDeatilLedgerState {
  final List<BillingDetails> response;
  GetUpiTansferSalereturnState({required this.response});
  @override
  List<Object?> get props => [response];
}

class GetUpiTansferSalereturnFailureState extends UpiTansferHistoryDeatilLedgerState {
  final String message;
  GetUpiTansferSalereturnFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
