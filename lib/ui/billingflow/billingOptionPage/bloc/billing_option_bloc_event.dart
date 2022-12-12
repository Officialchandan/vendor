import 'package:equatable/equatable.dart';

class BillingOptionBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetBillingDueAmmountEvent extends BillingOptionBlocEvent {
  GetBillingDueAmmountEvent();
}
