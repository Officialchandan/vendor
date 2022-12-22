part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

// ignore: must_be_immutable
class GetChatPapdiDueAmoutResponseSuccessState extends HomeState {
  final message;
  DueData data;
  final status;

  GetChatPapdiDueAmoutResponseSuccessState({
    required this.message,
    required this.data,
    this.status,
  });

  @override
  List<Object> get props => [message, data, status];
}

class GetFailureState extends HomeState {
  final String message;
  GetFailureState({required this.message});

  @override
  List<Object> get props => [message];
}
