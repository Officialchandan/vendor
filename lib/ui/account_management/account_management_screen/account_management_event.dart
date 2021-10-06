import 'package:equatable/equatable.dart';

class AccountManagementEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAccountManagementEvent extends AccountManagementEvent {
  final String mobile;
  GetAccountManagementEvent({required this.mobile});
}
