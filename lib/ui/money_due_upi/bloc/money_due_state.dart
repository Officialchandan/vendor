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

class GetFreeCoinInitialState extends MoneyDueState {
  @override
  List<Object?> get props => [];
}

class GetFreeCoinState extends MoneyDueState {
  final data;
  GetFreeCoinState({
    this.data,
  });
  @override
  List<Object?> get props => [data];
}

class GetFreeCoinFailureState extends MoneyDueState {
  final message;
  final succes;

  GetFreeCoinFailureState({this.message, this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetFreeCoinLoadingState extends MoneyDueState {
  @override
  List<Object?> get props => [];
}
