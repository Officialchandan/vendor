import 'package:equatable/equatable.dart';

class ChatPapdiBillingCustomerNumberResponseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetChatPapdiBillingCustomerNumberResponseEvent
    extends ChatPapdiBillingCustomerNumberResponseEvent {
  final String mobile;
  GetChatPapdiBillingCustomerNumberResponseEvent({required this.mobile});
  @override
  List<Object> get props => [mobile];
}

class GetChatPapdiBillingEvent
    extends ChatPapdiBillingCustomerNumberResponseEvent {
  final Map<String, dynamic> input;

  GetChatPapdiBillingEvent({required this.input});
  @override
  List<Object> get props => [input];
}

class GetChatPapdiBillingOtpEvent
    extends ChatPapdiBillingCustomerNumberResponseEvent {
  final Map<String, dynamic> input;

  GetChatPapdiBillingOtpEvent({required this.input});
  @override
  List<Object> get props => [input];
}
