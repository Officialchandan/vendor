import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/get_due_amount_response.dart';

class MoneyDueState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MoneyDueInitialState extends MoneyDueState {}

class GetDueAmountState extends MoneyDueState {
  final String dueAmount;
  final List<CategoryDueAmount> categoryDue;
  GetDueAmountState({required this.dueAmount, required this.categoryDue});

  @override
  List<Object?> get props => [dueAmount, categoryDue];
}

class GetCategoriesState extends MoneyDueState {
  final List<CategoryModel> categories;

  GetCategoriesState({required this.categories});

  @override
  List<Object?> get props => [categories];
}
