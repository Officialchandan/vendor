import 'package:equatable/equatable.dart';

abstract class CustomerNumberResponseState extends Equatable {}

class CustomerNumberResponseIntialState extends CustomerNumberResponseState {
  @override
  List<Object?> get props => [];
}

class GetCustomerNumberResponseState extends CustomerNumberResponseState {
  final message;
  GetCustomerNumberResponseState({this.message});

  @override
  List<Object> get props => [message];
}

class GetCustomerNumberResponseLoadingstate
    extends CustomerNumberResponseState {
  // final String message;
  // GetCustomerNumberResponseLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetCustomerNumberResponseFailureState
    extends CustomerNumberResponseState {
  final String message;
  GetCustomerNumberResponseFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
