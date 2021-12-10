import 'package:equatable/equatable.dart';

abstract class GiftSchemeState extends Equatable {}

class GiftSchemeIntialState extends GiftSchemeState {
  @override
  List<Object?> get props => [];
}

class GetGiftSchemeLoadingstate extends GiftSchemeState {
  @override
  List<Object?> get props => [];
}

class GetGiftSchemeFailureState extends GiftSchemeState {
  final String message;
  final succes;
  GetGiftSchemeFailureState({required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetGiftSchemestate extends GiftSchemeState {
  final message;
  final data;
  final succes;
  GetGiftSchemestate(
      {required this.succes, required this.message, required this.data});
  @override
  List<Object> get props => [message, data, succes];
}
