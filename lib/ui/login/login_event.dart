import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetLoginEvent extends LoginEvent {
  final mobile;
  GetLoginEvent({required this.mobile});

  @override
  List<Object?> get props => [mobile];
}

class GetLoginOtpEvent extends LoginEvent {
  final mobile;
  final otp;
  GetLoginOtpEvent({required this.mobile, required this.otp});

  @override
  List<Object?> get props => [mobile, otp];
}
