import 'package:equatable/equatable.dart';

abstract class ChatPapdiBillingCustomerNumberResponseState extends Equatable {}

class ChatPapdiBillingCustomerNumberResponseIntialState
    extends ChatPapdiBillingCustomerNumberResponseState {
  @override
  List<Object?> get props => [];
}

class GetChatPapdiBillingCustomerNumberResponseState
    extends ChatPapdiBillingCustomerNumberResponseState {
  final message;
  final data;
  final succes;
  final status;
  GetChatPapdiBillingCustomerNumberResponseState(
      {this.message, this.data, this.succes, this.status});

  @override
  List<Object> get props => [message, data, succes, status];
}

class GetChatPapdiBillingCustomerNumberResponseLoadingstate
    extends ChatPapdiBillingCustomerNumberResponseState {
  // final String message;
  // GetChatPapdiBillingCustomerNumberResponseLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetChatPapdiBillingCustomerNumberResponseFailureState
    extends ChatPapdiBillingCustomerNumberResponseState {
  final String message;
  final succes;
  final status;
  GetChatPapdiBillingCustomerNumberResponseFailureState(
      {required this.message, required this.succes, this.status});
  @override
  List<Object?> get props => [message, succes];
}

class GetChatPapdiBillingState
    extends ChatPapdiBillingCustomerNumberResponseState {
  final message;
  final data;
  final succes;

  GetChatPapdiBillingState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class GetChatPapdiBillingLoadingstate
    extends ChatPapdiBillingCustomerNumberResponseState {
  // final String message;
  // GetChatPapdiBillingLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetChatPapdiBillingFailureState
    extends ChatPapdiBillingCustomerNumberResponseState {
  final String message;
  final succes;
  GetChatPapdiBillingFailureState(
      {required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetChatPapdiBillingOtpState
    extends ChatPapdiBillingCustomerNumberResponseState {
  final message;
  final data;
  final succes;
  GetChatPapdiBillingOtpState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class GetChatPapdiBillingOtpLoadingstate
    extends ChatPapdiBillingCustomerNumberResponseState {
  // final String message;
  // GetChatPapdiBillingLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetChatPapdiBillingOtpFailureState
    extends ChatPapdiBillingCustomerNumberResponseState {
  final String message;
  final succes;
  GetChatPapdiBillingOtpFailureState(
      {required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetChatPapdiPartialUserState
    extends ChatPapdiBillingCustomerNumberResponseState {
  final message;
  final data;
  final succes;
  GetChatPapdiPartialUserState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class GetChatPapdiPartialUserLoadingstate
    extends ChatPapdiBillingCustomerNumberResponseState {
  // final String message;
  // GetChatPapdiBillingLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetChatPapdiPartialUserFailureState
    extends ChatPapdiBillingCustomerNumberResponseState {
  final String message;
  final succes;
  GetChatPapdiPartialUserFailureState(
      {required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}