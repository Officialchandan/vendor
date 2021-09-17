import 'package:equatable/equatable.dart';

class SearchByCategoriesEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductsSearchByCategoriesEvent extends SearchByCategoriesEvents {
  final String input;
  GetProductsSearchByCategoriesEvent({required this.input});
  @override
  List<Object?> get props => [input];
}

class GetCheckBoxSearchByCategoriesEvent extends SearchByCategoriesEvents {
  final bool check;
  final int index;
  GetCheckBoxSearchByCategoriesEvent(
      {required this.check, required this.index});
  @override
  List<Object?> get props => [check, index];
}

class GetIncrementSearchByCategoriesEvent extends SearchByCategoriesEvents {
  final count;
  GetIncrementSearchByCategoriesEvent({required this.count});
  @override
  List<Object?> get props => [count];
}

class GetDecrementSearchByCategoriesEvent extends SearchByCategoriesEvents {
  final count;
  GetDecrementSearchByCategoriesEvent({required this.count});
  @override
  List<Object?> get props => [count];
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
