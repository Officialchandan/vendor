import 'package:equatable/equatable.dart';

class SuggestedProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductEvent extends SuggestedProductEvent {
  final String categoryId;

  GetProductEvent({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class GetBrandsEvent extends SuggestedProductEvent {}

class GetCategoriesEvent extends SuggestedProductEvent {}

class ChangeTabEvent extends SuggestedProductEvent {
  final int index;

  ChangeTabEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class AddProductApiEvent extends SuggestedProductEvent {
  final String id;

  AddProductApiEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class CheckEvent extends SuggestedProductEvent {
  final int index;
  final bool check;

  CheckEvent({
    required this.index,
    required this.check,
  });

  @override
  List<Object?> get props => [index, check];
}
