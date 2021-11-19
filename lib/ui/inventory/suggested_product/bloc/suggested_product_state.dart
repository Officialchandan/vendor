import 'package:equatable/equatable.dart';
import 'package:vendor/model/get_brands_response.dart';
import 'package:vendor/model/get_categories_response.dart';
import 'package:vendor/model/product_model.dart';

class SuggestedProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingState extends SuggestedProductState {}

class SuggestedProductInitialState extends SuggestedProductState {}

class GetProductState extends SuggestedProductState {
  final List<ProductModel> products;

  GetProductState({required this.products});

  @override
  List<Object?> get props => [products];
}

class GetProductFailureState extends SuggestedProductState {
  final String message;

  GetProductFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddProductSuccessState extends SuggestedProductState {
  final String message;

  AddProductSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetBrandsState extends SuggestedProductState {
  final List<Brand> brands;

  GetBrandsState({required this.brands});

  @override
  List<Object?> get props => [brands];
}

class GetCategoryState extends SuggestedProductState {
  final List<CategoryModel> categories;

  GetCategoryState({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class ChangeTabState extends SuggestedProductState {
  final int index;

  ChangeTabState({required this.index});

  @override
  List<Object?> get props => [index];
}

class CheckState extends SuggestedProductState {
  final int index;
  final bool check;

  CheckState({
    required this.index,
    required this.check,
  });

  @override
  List<Object?> get props => [index, check];
}
