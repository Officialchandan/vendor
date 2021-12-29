import 'package:equatable/equatable.dart';

class NotificationEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetNotificationEvent extends NotificationEvents {}

class MarkAsReadEvent extends NotificationEvents {
  final Map input;
  MarkAsReadEvent({required this.input});
  @override
  List<Object?> get props => [input];
}
