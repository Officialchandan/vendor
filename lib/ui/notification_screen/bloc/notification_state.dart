import 'package:equatable/equatable.dart';
import 'package:vendor/model/vendor_profile_response.dart';
import 'package:vendor/ui/notification_screen/model/notification_response.dart';

class NotificationStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetNotificationInitialState extends NotificationStates {}

class GetNotificationLoadingState extends NotificationStates {}

class GetNotificationSuccessState extends NotificationStates {
  final List<NotificationData>? data;
  GetNotificationSuccessState({this.data});
  @override
  List<Object?> get props => [data];
}

class GetNotificationFailureState extends NotificationStates {
  final String message;
  GetNotificationFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class MarkAsReadSucessState extends NotificationStates {
  final String message;
  MarkAsReadSucessState({required this.message});
  @override
  List<Object?> get props => [message];
}

class MarkAsReadFailureState extends NotificationStates {
  final String message;
  MarkAsReadFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
