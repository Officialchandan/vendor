import 'package:equatable/equatable.dart';

class FreeCoinHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetFreeCoinsHistoryEvent extends FreeCoinHistoryEvent {
  @override
  List<Object?> get props => [];
}

class FindUserEvent extends FreeCoinHistoryEvent {
  final searchkeyword;

  FindUserEvent({required this.searchkeyword});
  List<Object?> get props => [searchkeyword];
}
