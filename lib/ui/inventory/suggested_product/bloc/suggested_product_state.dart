import 'package:equatable/equatable.dart';

class SuggestedProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SuggestedProductInitialState extends SuggestedProductState {}

class GetProductState extends SuggestedProductState {
  GetProductState();

  @override
  List<Object?> get props => [];
}

class ChangeTabState extends SuggestedProductState {
  final int index;

  ChangeTabState({required this.index});

  @override
  List<Object?> get props => [index];
}
