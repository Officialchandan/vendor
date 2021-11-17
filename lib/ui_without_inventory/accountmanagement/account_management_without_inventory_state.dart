import 'package:equatable/equatable.dart';

abstract class AccountManagementWithoutInventoryState extends Equatable {}

class AccountManagementWithoutInventoryIntialState
    extends AccountManagementWithoutInventoryState {
  @override
  List<Object?> get props => [];
}

class GetAccountManagementWithoutInventoryState
    extends AccountManagementWithoutInventoryState {
  final message;
  final data;
  final succes;
  GetAccountManagementWithoutInventoryState(
      {required this.message, required this.data, required this.succes});

  @override
  List<Object> get props => [message, data, succes];
}

class GetAccountManagementWithoutInventoryLoadingstate
    extends AccountManagementWithoutInventoryState {
  @override
  List<Object?> get props => [];
}

class GetAccountManagementWithoutInventoryFailureState
    extends AccountManagementWithoutInventoryState {
  final String message;
  final succes;
  GetAccountManagementWithoutInventoryFailureState(
      {required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}
