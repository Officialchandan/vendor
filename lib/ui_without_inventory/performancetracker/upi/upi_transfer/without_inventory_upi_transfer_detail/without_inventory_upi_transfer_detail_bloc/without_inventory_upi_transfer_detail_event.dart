import 'package:equatable/equatable.dart';

class UpiTansferHistoryDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryDetailEvent extends UpiTansferHistoryDetailEvent {
  final Map<String, dynamic> input;
  GetUpiTansferHistoryDetailEvent({required this.input});
  @override
  List<Object?> get props => [];
}
