import 'package:equatable/equatable.dart';
import 'package:vendor/model/getdue_amount_by_day.dart';

abstract class BillingOptionBlocState extends Equatable {}

class BillingOptionBlocInitial extends BillingOptionBlocState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class getBillingOptionsDueAmoutResponseState extends BillingOptionBlocState {
  final message;
  DueData data;
  final status;

  getBillingOptionsDueAmoutResponseState({
    required this.message,
    required this.data,
    this.status,
  });

  @override
  List<Object> get props => [message, data, status];
}
