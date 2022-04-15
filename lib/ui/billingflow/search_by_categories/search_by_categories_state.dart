import 'package:equatable/equatable.dart';

abstract class SearchByCategoriesState extends Equatable {}

class SearchByCategoriesInitialState extends SearchByCategoriesState {
  @override
  List<Object?> get props => [];
}

class SearchByCategoriesLoadingState extends SearchByCategoriesState {
  @override
  List<Object?> get props => [];
}

class GetSearchByCategoriesState extends SearchByCategoriesState {
  final String message;
  final data;

  GetSearchByCategoriesState({required this.message, required this.data});

  @override
  List<Object?> get props => [message];
}

class SearchByCategoriesFailureState extends SearchByCategoriesState {
  final String message;

  SearchByCategoriesFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SearchByCategoriesCheckBoxState extends SearchByCategoriesState {
  final bool check;
  final int index;

  SearchByCategoriesCheckBoxState({required this.check, required this.index});

  @override
  List<Object?> get props => [check, index];
}

class SearchByCategoriesIncrementState extends SearchByCategoriesState {
  final int count;
  final int index;

  SearchByCategoriesIncrementState({required this.count, required this.index});

  @override
  List<Object?> get props => [count, index];
}

class SearchByCategoriesDecrementState extends SearchByCategoriesState {
  final int count;
  final int index;

  SearchByCategoriesDecrementState({required this.count, required this.index});

  @override
  List<Object?> get props => [count, index];
}

class SearchByCategoriesSearchState extends SearchByCategoriesState {
  final String searchword;

  SearchByCategoriesSearchState({required this.searchword});

  @override
  List<Object?> get props => [searchword];
}

class SearchByCategoriesClosedState extends SearchByCategoriesState {
  @override
  List<Object?> get props => throw UnimplementedError();
}
