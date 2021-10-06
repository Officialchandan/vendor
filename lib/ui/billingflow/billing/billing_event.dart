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
