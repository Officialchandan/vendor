import 'package:equatable/equatable.dart';

class CustomerNumberResponseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCustomerNumberResponseEvent extends CustomerNumberResponseEvent {
  final mobile;
  GetCustomerNumberResponseEvent({required this.mobile});
}

class GetVendorCategoryEvent extends CustomerNumberResponseEvent {
  final vendorid;
  GetVendorCategoryEvent({required this.vendorid});
}
