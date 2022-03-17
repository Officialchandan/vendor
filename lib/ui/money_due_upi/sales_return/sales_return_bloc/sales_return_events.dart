import 'package:equatable/equatable.dart';
import 'package:vendor/ui/inventory/sale_return/bloc/sale_return_event.dart';

class SalesReturnEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetSalesReturnHistoryEvent extends SalesReturnEvents {
  final Map input;
  GetSalesReturnHistoryEvent({required this.input});
  @override
  List<Object?> get props => [input];
}
