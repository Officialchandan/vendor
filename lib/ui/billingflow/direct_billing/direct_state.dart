import 'package:equatable/equatable.dart';

abstract class DirectBillingCustomerNumberResponseState extends Equatable {}

class DirectBillingCustomerNumberResponseIntialState
    extends DirectBillingCustomerNumberResponseState {
  @override
  List<Object?> get props => [];
}

class GetDirectBillingCustomerNumberResponseState
    extends DirectBillingCustomerNumberResponseState {
  final message;
  final data;
  final status;
  final succes;
  final firstName;
  final lastName;
  GetDirectBillingCustomerNumberResponseState(
      {this.message,
      this.status,
      this.data,
      this.succes,
      this.firstName,
      this.lastName});

  @override
  List<Object> get props => [message, data, succes, firstName, lastName];
}

class GetDirectBillingCustomerNumberResponseLoadingstate
    extends DirectBillingCustomerNumberResponseState {
  // final String message;
  // GetDirectBillingCustomerNumberResponseLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetDirectBillingCustomerNumberResponseFailureState
    extends DirectBillingCustomerNumberResponseState {
  final String message;
  final succes;
  final status;
  GetDirectBillingCustomerNumberResponseFailureState(
      {required this.message, this.status, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetDirectBillingState extends DirectBillingCustomerNumberResponseState {
  final message;
  final data;
  final succes;
  GetDirectBillingState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class ResendOtpDirectBillingState
    extends DirectBillingCustomerNumberResponseState {
  final message;
  final data;
  final succes;
  ResendOtpDirectBillingState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class GetDirectBillingLoadingstate
    extends DirectBillingCustomerNumberResponseState {
  // final String message;
  // GetDirectBillingLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetDirectBillingFailureState
    extends DirectBillingCustomerNumberResponseState {
  final String message;
  final succes;
  GetDirectBillingFailureState({required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetDirectBillingOtpState
    extends DirectBillingCustomerNumberResponseState {
  final message;
  final data;
  final succes;
  GetDirectBillingOtpState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class GetDirectBillingOtpLoadingstate
    extends DirectBillingCustomerNumberResponseState {
  // final String message;
  // GetDirectBillingLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetDirectBillingOtpFailureState
    extends DirectBillingCustomerNumberResponseState {
  final String message;
  final succes;
  GetDirectBillingOtpFailureState(
      {required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetDirectBillingPartialUserState
    extends DirectBillingCustomerNumberResponseState {
  final message;
  final data;
  final succes;
  GetDirectBillingPartialUserState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class GetDirectBillingPartialUserLoadingstate
    extends DirectBillingCustomerNumberResponseState {
  // final String message;
  // GetDirectBillingBillingLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetDirectBillingPartialUserFailureState
    extends DirectBillingCustomerNumberResponseState {
  final String message;
  final succes;
  GetDirectBillingPartialUserFailureState(
      {required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetDirectBillingCategoryByVendorIdState
    extends DirectBillingCustomerNumberResponseState {
  final message;
  final data;
  GetDirectBillingCategoryByVendorIdState({this.message, this.data});
  @override
  List<Object?> get props => [message, data];
}

class GetDirectBillingCategoryByVendorIdFailureState
    extends DirectBillingCustomerNumberResponseState {
  final String message;
  GetDirectBillingCategoryByVendorIdFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class DirectBillingCheckBoxState
    extends DirectBillingCustomerNumberResponseState {
  final int index;
  final bool isChecked;
  DirectBillingCheckBoxState({required this.index, required this.isChecked});
  @override
  List<Object?> get props => [index, isChecked];
}

class DirectBillingRedeemCheckBoxState
    extends DirectBillingCustomerNumberResponseState {
  final bool isChecked;
  DirectBillingRedeemCheckBoxState({required this.isChecked});
  @override
  List<Object?> get props => [isChecked];
}

class DirectBillingLoadingState
    extends DirectBillingCustomerNumberResponseState {
  DirectBillingLoadingState();
  @override
  List<Object?> get props => [];
}
