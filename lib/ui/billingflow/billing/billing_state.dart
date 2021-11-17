import 'package:equatable/equatable.dart';

abstract class CustomerNumberResponseState extends Equatable {}

class CustomerNumberResponseIntialState extends CustomerNumberResponseState {
  @override
  List<Object?> get props => [];
}

class GetCustomerNumberResponseState extends CustomerNumberResponseState {
  final message;
  final status;
  final data;
  final succes;
  GetCustomerNumberResponseState(
      {this.message, this.status, this.data, this.succes});

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
  final status;
  final succes;
  GetCustomerNumberResponseFailureState(
      {required this.message, this.status, required this.succes});
  @override
  List<Object?> get props => [message, status, succes];
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

class GetBillingPartialUserState extends CustomerNumberResponseState {
  final message;
  final data;
  final succes;
  GetBillingPartialUserState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class GetBillingPartialUserLoadingstate extends CustomerNumberResponseState {
  // final String message;
  // GetBillingBillingLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetBillingPartialUserFailureState extends CustomerNumberResponseState {
  final String message;
  final succes;
  GetBillingPartialUserFailureState(
      {required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}
