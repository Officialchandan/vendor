import 'package:equatable/equatable.dart';

class DirectBillingCustomerNumberResponseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDirectBillingCustomerNumberResponseEvent
    extends DirectBillingCustomerNumberResponseEvent {
  final String mobile;

  GetDirectBillingCustomerNumberResponseEvent({required this.mobile});

  @override
  List<Object> get props => [mobile];
}

class GetDirectBillingEvent extends DirectBillingCustomerNumberResponseEvent {
  final Map<String, dynamic> input;

  GetDirectBillingEvent({required this.input});

  @override
  List<Object> get props => [input];
}

class ResendOtpDirectBillingEvent
    extends DirectBillingCustomerNumberResponseEvent {
  final Map<String, dynamic> input;

  ResendOtpDirectBillingEvent({required this.input});

  @override
  List<Object> get props => [input];
}

class GetDirectBillingOtpEvent
    extends DirectBillingCustomerNumberResponseEvent {
  final Map<String, dynamic> input;

  GetDirectBillingOtpEvent({required this.input});

  @override
  List<Object> get props => [input];
}

class GetDirectBillingPartialUserRegisterEvent
    extends DirectBillingCustomerNumberResponseEvent {
  final Map<String, dynamic> input;

  GetDirectBillingPartialUserRegisterEvent({required this.input});
  @override
  List<Object> get props => [input];
}

class GetDirectBillingCategoryEvent
    extends DirectBillingCustomerNumberResponseEvent {
  GetDirectBillingCategoryEvent();
}

class GetDirectBillingCheckBoxEvent
    extends DirectBillingCustomerNumberResponseEvent {
  final int index;
  final bool isChecked;
  GetDirectBillingCheckBoxEvent({required this.index, required this.isChecked});
  @override
  List<Object> get props => [isChecked, index];
}

class GetDirectBillingRedeemCheckBoxEvent
    extends DirectBillingCustomerNumberResponseEvent {
  final bool isChecked;
  GetDirectBillingRedeemCheckBoxEvent({required this.isChecked});
  @override
  List<Object> get props => [isChecked];
}
