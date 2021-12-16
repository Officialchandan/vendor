import 'package:equatable/equatable.dart';

class ScannerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetScannerEvent extends ScannerEvent {
  final Map<String, dynamic> data;

  GetScannerEvent({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}
