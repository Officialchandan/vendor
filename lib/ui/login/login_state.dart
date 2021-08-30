import 'package:equatable/equatable.dart';
import 'package:vendor/model/login_otp.dart';
import 'package:vendor/model/login_response.dart';

abstract class LoginState extends Equatable {}

class LoginIntialState extends LoginState {
  @override
  List<Object?> get props => [];
}

class GetLoginState extends LoginState {
  final message;
  GetLoginState(this.message);

  @override
  List<Object> get props => [message];
}

class GetLoginOtpState extends LoginState {
  final message;
  GetLoginOtpState(this.message);

  @override
  List<Object> get props => [message];
}

class GetLoginFailureState extends LoginState {
  final String message;
  GetLoginFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
