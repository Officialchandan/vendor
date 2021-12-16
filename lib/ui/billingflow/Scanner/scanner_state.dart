import 'package:equatable/equatable.dart';

abstract class ScannerState extends Equatable {}

class IntitalScannerstate extends ScannerState {
  IntitalScannerstate();

  @override
  List<Object?> get props => [];
}

class GetScannerState extends ScannerState {
  final message;

  final succes;

  GetScannerState({this.message, this.succes});

  @override
  List<Object> get props => [message, succes];
}

class GetScannerStateLoadingstate extends ScannerState {
  // final String message;
  // GetCustomerNumberResponseLoadingstate({required this.message});
  @override
  List<Object?> get props => [];
}

class GetScannerStateFailureState extends ScannerState {
  final String message;
  final succes;

  GetScannerStateFailureState({required this.message, required this.succes});

  @override
  List<Object?> get props => [message, succes];
}
