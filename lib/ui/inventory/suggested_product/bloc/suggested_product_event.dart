import 'package:equatable/equatable.dart';

class SuggestedProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductEvent extends SuggestedProductEvent {}

class ChangeTabEvent extends SuggestedProductEvent {
  final int index;

  ChangeTabEvent({required this.index});

  @override
  List<Object?> get props => [index];
}
