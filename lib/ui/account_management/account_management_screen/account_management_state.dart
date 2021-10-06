import 'package:equatable/equatable.dart';

abstract class AccountManagementState extends Equatable {}

class CustomerNumberResponseIntialState extends AccountManagementState {
  @override
  List<Object?> get props => [];
}

class GetAccountManagementState extends AccountManagementState {
  final message;
  final data;
  final succes;
  GetAccountManagementState({this.message, this.data, this.succes});

  @override
  List<Object> get props => [message, data, succes];
}
