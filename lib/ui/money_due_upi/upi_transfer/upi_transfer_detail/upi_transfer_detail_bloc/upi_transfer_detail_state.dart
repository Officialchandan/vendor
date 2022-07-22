import 'package:equatable/equatable.dart';
import 'package:vendor/model/upi_tansfer_detail_response.dart';

class UpiTansferHistoryDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryDetailInitialState extends UpiTansferHistoryDetailState {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryDetailState extends UpiTansferHistoryDetailState {
  final List<UpiHistroyOrdersData>? data;
  GetUpiTansferHistoryDetailState({this.data});
  @override
  List<Object?> get props => [data];
}

class GetUpiTansferHistoryDetailLoadingState extends UpiTansferHistoryDetailState {
  @override
  List<Object?> get props => [];
}

class GetUpiTansferHistoryDetailFailureState extends UpiTansferHistoryDetailState {
  final message;
  final succes;
  GetUpiTansferHistoryDetailFailureState({this.message, this.succes});
  @override
  List<Object?> get props => [message, succes];
}
