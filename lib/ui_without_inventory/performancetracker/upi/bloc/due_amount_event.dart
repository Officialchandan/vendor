import 'package:equatable/equatable.dart';

class MoneyDueEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDueAmount extends MoneyDueEvent {}

class GetCategories extends MoneyDueEvent {}
