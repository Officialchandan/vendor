import 'package:equatable/equatable.dart';

abstract class CustomerNumberResponseState extends Equatable {}

class CustomerNumberResponseIntialState extends CustomerNumberResponseState {
  @override
  List<Object?> get props => [];
}

class GetCustomerNumberResponseState extends CustomerNumberResponseState {
  final message;
  final data;
  final succes;
  GetCustomerNumberResponseState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
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
  final succes;
  GetCustomerNumberResponseFailureState(
      {required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetCategoryByVendorIdLoadingstate extends CustomerNumberResponseState {
  // final String message;
  // GetCustomerNumberResponseLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetCategoryByVendorIdState extends CustomerNumberResponseState {
  final message;
  final data;
  GetCategoryByVendorIdState({this.message, this.data});

  @override
  List<Object> get props => [message, data];
}

class GetCategoryByVendorIdFailureState extends CustomerNumberResponseState {
  final String message;
  GetCategoryByVendorIdFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
