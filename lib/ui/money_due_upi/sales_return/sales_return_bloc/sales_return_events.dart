import 'package:equatable/equatable.dart';

class SalesReturnStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class SalesReturnInitialState extends SalesReturnStates {}

class SalesReturnLoadingState extends SalesReturnStates {}

class SalesReturnSuccessState extends SalesReturnStates {
  final String response;
  SalesReturnSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class SalesReturnFailureState extends SalesReturnStates {
  final String message;
  SalesReturnFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
