import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_categories_response.dart';

class MoneyDueState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MoneyDueInitialState extends MoneyDueState {}

class GetDueAmountState extends MoneyDueState {
  final String dueAmount;

  GetDueAmountState({required this.dueAmount});

  @override
  List<Object?> get props => [dueAmount];
}

class GetCategoriesState extends MoneyDueState {
  final List<CategoryModel> categories;

  GetCategoriesState({required this.categories});

  @override
  List<Object?> get props => [categories];
}
