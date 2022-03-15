import 'package:equatable/equatable.dart';

class RedeemCoinEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRedeemCoinDataEvent extends RedeemCoinEvents {
  GetRedeemCoinDataEvent({required this.input});
  final Map<String, dynamic> input;
  @override
  List<Object?> get props => [input];
}

class RedeemDataSearchEvent extends RedeemCoinEvents {
  RedeemDataSearchEvent({required this.keyWord});
  final String keyWord;
  @override
  List<Object?> get props => [keyWord];
}
