import 'package:equatable/equatable.dart';

abstract class SearchByCategoriesState extends Equatable {}

class SearchByCategoriesIntialState extends SearchByCategoriesState {
  @override
  List<Object?> get props => [];
}

class GetSearchByCategoriesLoadingState extends SearchByCategoriesState {
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

class GetSearchByCategoriesFailureState extends SearchByCategoriesState {
  final String message;
  GetSearchByCategoriesFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class GetSearchByCategoriesCheckBoxState extends SearchByCategoriesState {
  final bool check;
  final int index;
  GetSearchByCategoriesCheckBoxState({required this.check, required this.index});

  @override
  List<Object?> get props => [check, index];
}

class GetSearchByCategoriesIcrementState extends SearchByCategoriesState {
  final int count;
  GetSearchByCategoriesIcrementState({required this.count});

  @override
  List<Object?> get props => [count];
}

class GetSearchByCategoriesDecrementState extends SearchByCategoriesState {
  final int count;
  GetSearchByCategoriesDecrementState({required this.count});

  @override
  List<Object?> get props => [count];
}

class SearchByCategoriesInitialState extends SearchByCategoriesState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class SearchByCategoriesLoadingState extends SearchByCategoriesState {
  @override
  // TODO: implement props
  // TODO: implement props
  List<Object?> get props => [];
}

class SearchByCategoriesSearchState extends SearchByCategoriesState {
  final String searchword;
  SearchByCategoriesSearchState({required this.searchword});

  @override
  // TODO: implement props
  List<Object?> get props => [searchword];
}

class SearchByCategoriesClosedState extends SearchByCategoriesState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
