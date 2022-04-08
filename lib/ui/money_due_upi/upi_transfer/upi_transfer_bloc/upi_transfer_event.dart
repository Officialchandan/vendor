import 'package:equatable/equatable.dart';

class UpiTansferHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryEvent extends UpiTansferHistoryEvent {
  final Map<String, dynamic> input;
  GetUpiTansferHistoryEvent({required this.input});
  @override
  List<Object?> get props => [];
}

class FindUserEvent extends UpiTansferHistoryEvent {
  final searchkeyword;

  FindUserEvent({required this.searchkeyword});
  List<Object?> get props => [searchkeyword];
}
