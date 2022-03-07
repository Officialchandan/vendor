import 'package:equatable/equatable.dart';

class SalesReturnDetailsStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class SalesReturnDetailsInitialState extends SalesReturnDetailsStates {}

class SalesReturnDetailsLoadingState extends SalesReturnDetailsStates {}

class SalesReturnDetailsSuccessState extends SalesReturnDetailsStates {
  final String response;
  SalesReturnDetailsSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class SalesReturnDetailsFailureState extends SalesReturnDetailsStates {
  final String message;
  SalesReturnDetailsFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
