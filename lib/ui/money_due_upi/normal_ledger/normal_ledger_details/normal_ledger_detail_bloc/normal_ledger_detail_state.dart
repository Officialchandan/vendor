import 'package:equatable/equatable.dart';

import '../../../sales_return/response/upi_sales_return_response.dart';

class NormalLedgerDetailStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class NormalLedgerDetailInitialState extends NormalLedgerDetailStates {}

class NormalLedgerDetailLoadingState extends NormalLedgerDetailStates {}

class NormalLedgerDetailHistoryState extends NormalLedgerDetailStates {
  final List<BillingDetails> response;
  NormalLedgerDetailHistoryState({required this.response});
  @override
  List<Object?> get props => [response];
}

class NormalLedgerDetailFailureState extends NormalLedgerDetailStates {
  final String message;
  NormalLedgerDetailFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
