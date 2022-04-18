import 'package:equatable/equatable.dart';

class SearchByCategoriesEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductsSearchByCategoriesEvent extends SearchByCategoriesEvents {
  final String input;

  ProductsSearchByCategoriesEvent({required this.input});

  @override
  List<Object?> get props => [input];
}

class CheckBoxSearchByCategoriesEvent extends SearchByCategoriesEvents {
  final bool check;
  final int index;

  CheckBoxSearchByCategoriesEvent({required this.check, required this.index});

  @override
  List<Object?> get props => [check, index];
}

class SearchByCategoriesIncrementEvent extends SearchByCategoriesEvents {
  final int count;
  final int index;

  SearchByCategoriesIncrementEvent({required this.count, required this.index});

  @override
  List<Object?> get props => [count, index];
}

class SearchByCategoriesDecrementEvent extends SearchByCategoriesEvents {
  final int  count;
  final int index;

  SearchByCategoriesDecrementEvent({required this.count, required this.index});

  @override
  List<Object?> get props => [count, index];
}

class GetAddSearchByCategoriesEvent extends SearchByCategoriesEvents {
  GetAddSearchByCategoriesEvent();
}

class GetSelectSizeSearchByCategoriesEvent extends SearchByCategoriesEvents {
  final size;
  GetSelectSizeSearchByCategoriesEvent({required this.size});
}

class GetSelectColorSearchByCategoriesEvent extends SearchByCategoriesEvents {
  final color;

  GetSelectColorSearchByCategoriesEvent({required this.color});
}

class LoadingSearchByCategoriesEvent extends SearchByCategoriesEvents {
  final context;

  LoadingSearchByCategoriesEvent({required this.context});
}

class SuccessSearchByCategoriesEvent extends SearchByCategoriesEvents {}

class FailureSearchByCategoriesEvent extends SearchByCategoriesEvents {}

class FindSearchByCategoriesEvent extends SearchByCategoriesEvents {
  final searchkeyword;

  FindSearchByCategoriesEvent({required this.searchkeyword});
}

class FindSearchByCategoriesClosedEvent extends SearchByCategoriesEvents {}
