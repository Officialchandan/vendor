import 'package:equatable/equatable.dart';


abstract class LoginState extends Equatable {}

class LoginInitialState extends LoginState {
  @override
  List<Object?> get props => [];
}

class GetLoginState extends LoginState {
  final message;
  GetLoginState(this.message);

  @override
  List<Object> get props => [message];
}

class GetResendOptState extends LoginState {
  final bool isCheckStatus;
  GetResendOptState({required this.isCheckStatus});

  @override
  List<Object> get props => [isCheckStatus];
}

class LoadingState extends LoginState {
  LoadingState();
  @override
  List<Object?> get props => [];
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
