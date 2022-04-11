import 'package:equatable/equatable.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';

class DailyLedgerDetailStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class DailyLedgerDetailInitialState extends DailyLedgerDetailStates {}

class DailyLedgerDetailLoadingState extends DailyLedgerDetailStates {}

class DailyLedgerDetailHistoryState extends DailyLedgerDetailStates {
  final List<BillingDetails> response;
  DailyLedgerDetailHistoryState({required this.response});
  @override
  List<Object?> get props => [response];
}

class DailyLedgerDetailFailureState extends DailyLedgerDetailStates {
  final String message;
  DailyLedgerDetailFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
