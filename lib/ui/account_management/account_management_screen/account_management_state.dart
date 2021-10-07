import 'package:equatable/equatable.dart';

abstract class AccountManagementState extends Equatable {}

class AccountManagementIntialState extends AccountManagementState {
  @override
  List<Object?> get props => [];
}

class GetAccountManagementState extends AccountManagementState {
  final message;
  final data;
  final succes;
  GetAccountManagementState(
      {required this.message, required this.data, required this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class GetAccountManagementLoadingstate extends AccountManagementState {
  @override
  List<Object?> get props => [];
}

class GetAccountManagementFailureState extends AccountManagementState {
  final String message;
  final succes;
  GetAccountManagementFailureState(
      {required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}
