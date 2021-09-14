import 'package:equatable/equatable.dart';

class SearchAllEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductsEvent extends SearchAllEvent {
  GetProductsEvent();
}

class GetCheckBoxEvent extends SearchAllEvent {
  final bool check;
  final int index;
  GetCheckBoxEvent({required this.check, required this.index});
  @override
  List<Object?> get props => [check, index];
}

class GetIncrementEvent extends SearchAllEvent {
  final count;
  GetIncrementEvent({required this.count});
  @override
  List<Object?> get props => [count];
}

class GetDecrementEvent extends SearchAllEvent {
  final count;
  GetDecrementEvent({required this.count});
  @override
  List<Object?> get props => [count];
}

class GetAddEvent extends SearchAllEvent {
  GetAddEvent();
}

class GetSelectSizeEvent extends SearchAllEvent {
  final size;
  GetSelectSizeEvent({required this.size});
}

class GetSelectColorEvent extends SearchAllEvent {
  final color;
  GetSelectColorEvent({required this.color});
}

class LoadingSearchCategoriesEvent extends SearchAllEvent {
  final context;

  LoadingSearchCategoriesEvent({required this.context});
}

class SuccessSearchCategoriesEvent extends SearchAllEvent {}

class FailureSearchCategoriesEvent extends SearchAllEvent {}

class FindCategoriesEvent extends SearchAllEvent {
  final searchkeyword;

  FindCategoriesEvent({required this.searchkeyword});
}

class FindCategoriesClosedEvent extends SearchAllEvent {}
