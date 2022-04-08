import 'package:equatable/equatable.dart';
import 'package:vendor/model/upi_transfer_history.dart';

class UpiTansferHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryInitialState extends UpiTansferHistoryState {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryState extends UpiTansferHistoryState {
  final List<UpiTansferData>? data;
  GetUpiTansferHistoryState({this.data});
  @override
  List<Object?> get props => [data];
}

class GetUpiTansferHistoryLoadingState extends UpiTansferHistoryState {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryFailureState extends UpiTansferHistoryState {
  final message;
  final succes;
  GetUpiTansferHistoryFailureState({this.message, this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetTansferHistoryUserSearchState extends UpiTansferHistoryState {
  final String searchword;
  GetTansferHistoryUserSearchState({required this.searchword});

  @override
  // TODO: implement props
  List<Object?> get props => [searchword];
}
