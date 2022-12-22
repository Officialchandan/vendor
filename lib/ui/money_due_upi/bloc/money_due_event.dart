import 'package:equatable/equatable.dart';

class MoneyDueEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDueAmount extends MoneyDueEvent {}

class GetredeemEarnDataEvent extends MoneyDueEvent {}

class GetFreeCoins extends MoneyDueEvent {
  @override
  List<Object?> get props => [];
}

class GetInitiateTransiction extends MoneyDueEvent {
  final Map<String, dynamic> input;
  GetInitiateTransiction(this.input);
  @override
  List<Object?> get props => [input];
}
