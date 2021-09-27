import 'package:equatable/equatable.dart';

class SaleReturnEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPurchasedProductEvent extends SaleReturnEvent {
  final String mobile;

  GetPurchasedProductEvent({required this.mobile});

  @override
  List<Object?> get props => [mobile];
}

class SaleReturnApiEvent extends SaleReturnEvent {
  final Map input;

  SaleReturnApiEvent({required this.input});

  @override
  List<Object?> get props => [input];
}

class VerifyOtpEvent extends SaleReturnEvent {
  final Map input;

  VerifyOtpEvent({required this.input});

  @override
  List<Object?> get props => [input];
}
