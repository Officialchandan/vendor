import 'package:equatable/equatable.dart';

class SalesReturnEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetSalesReturnHistoryEvent extends SalesReturnEvents {
  final Map<String, dynamic> input;
  GetSalesReturnHistoryEvent({required this.input});
  @override
  List<Object?> get props => [input];
}
