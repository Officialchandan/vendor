import 'package:equatable/equatable.dart';
import 'package:vendor/ui/money_due_upi/sales_return/response/upi_sales_return_response.dart';

class SalesReturnStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class SalesReturnInitialState extends SalesReturnStates {}

class SalesReturnLoadingState extends SalesReturnStates {}

class SalesReturnHistoryState extends SalesReturnStates {
  final List<BillingDetails> response;
  SalesReturnHistoryState({required this.response});
  @override
  List<Object?> get props => [response];
}

class SalesReturnFailureState extends SalesReturnStates {
  final String message;
  SalesReturnFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
