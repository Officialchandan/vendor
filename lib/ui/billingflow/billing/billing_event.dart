import 'package:equatable/equatable.dart';

class CustomerNumberResponseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCustomerNumberResponseEvent extends CustomerNumberResponseEvent {
  final String mobile;
  GetCustomerNumberResponseEvent({required this.mobile});
}

class GetVendorCategoryEvent extends CustomerNumberResponseEvent {
  GetVendorCategoryEvent();
}

class GetBillingPartialUserRegisterEvent extends CustomerNumberResponseEvent {
  final Map<String, dynamic> input;

  GetBillingPartialUserRegisterEvent({required this.input});
  @override
  List<Object> get props => [input];
}

class GetBillingDueAmmountEvent extends CustomerNumberResponseEvent {
  GetBillingDueAmmountEvent();
}
