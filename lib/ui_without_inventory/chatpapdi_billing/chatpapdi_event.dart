import 'package:equatable/equatable.dart';

class ChatPapdiBillingCustomerNumberResponseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetChatPapdiBillingCustomerNumberResponseEvent extends ChatPapdiBillingCustomerNumberResponseEvent {
  final String mobile;
  GetChatPapdiBillingCustomerNumberResponseEvent({required this.mobile});
  @override
  List<Object> get props => [mobile];
}

class GetChatPapdiBillingEvent extends ChatPapdiBillingCustomerNumberResponseEvent {
  final Map<String, dynamic> input;

  GetChatPapdiBillingEvent({required this.input});
  @override
  List<Object> get props => [input];
}

class GetDirectBillingCheckBoxEvent extends ChatPapdiBillingCustomerNumberResponseEvent {
  final int index;
  final bool isChecked;
  GetDirectBillingCheckBoxEvent({required this.index, required this.isChecked});
  @override
  List<Object> get props => [isChecked, index];
}

class GetChatPapdiBillingOtpEvent extends ChatPapdiBillingCustomerNumberResponseEvent {
  final Map<String, dynamic> input;

  GetChatPapdiBillingOtpEvent({required this.input});
  @override
  List<Object> get props => [input];
}

class GetChatPapdiPartialUserRegisterEvent extends ChatPapdiBillingCustomerNumberResponseEvent {
  final Map<String, dynamic> input;

  GetChatPapdiPartialUserRegisterEvent({required this.input});
  @override
  List<Object> get props => [input];
}

class ChatPapdiCheckBoxEvent extends ChatPapdiBillingCustomerNumberResponseEvent {
  final bool isChecked;
  ChatPapdiCheckBoxEvent({required this.isChecked});
  @override
  List<Object> get props => [isChecked];
}

class GetDirectBillingCategoryEvent extends ChatPapdiBillingCustomerNumberResponseEvent {
  GetDirectBillingCategoryEvent();
}
