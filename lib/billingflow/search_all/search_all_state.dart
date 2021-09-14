import 'package:equatable/equatable.dart';

abstract class SearchAllState extends Equatable {}

class SearchAllIntialState extends SearchAllState {
  @override
  List<Object?> get props => [];
}

class GetSearchLoadingState extends SearchAllState {
  @override
  List<Object?> get props => [];
}

class GetSearchState extends SearchAllState {
  final String message;
  final data;
  GetSearchState({required this.message, required this.data});
  @override
  List<Object?> get props => [message];
}

class GetSearchFailureState extends SearchAllState {
  final String message;
  GetSearchFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}

class GetCheckBoxState extends SearchAllState {
  final bool check;
  final int index;
  GetCheckBoxState({required this.check, required this.index});

  @override
  List<Object?> get props => [check, index];
}

class GetIcrementState extends SearchAllState {
  final int count;
  GetIcrementState({required this.count});

  @override
  List<Object?> get props => [count];
}

class GetDecrementState extends SearchAllState {
  final int count;
  GetDecrementState({required this.count});

  @override
  List<Object?> get props => [count];
}

class CategoriesInitialState extends SearchAllState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CategoriesLoadingState extends SearchAllState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CategoriesSearchState extends SearchAllState {
  final String searchword;
  CategoriesSearchState({required this.searchword});

  @override
  // TODO: implement props
  List<Object?> get props => [searchword];
}

class CategoriesClosedState extends SearchAllState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
