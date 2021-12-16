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

class GiftDeliverdIntialState extends GiftSchemeState {
  @override
  List<Object?> get props => [];
}

class GetGiftDeliverdLoadingstate extends GiftSchemeState {
  @override
  List<Object?> get props => [];
}

class GetGiftDeliverdFailureState extends GiftSchemeState {
  final String message;
  final succes;
  GetGiftDeliverdFailureState({required this.message, required this.succes});
  @override
  List<Object?> get props => [message, succes];
}

class GetGiftDeliverdstate extends GiftSchemeState {
  final message;

  final succes;
  GetGiftDeliverdstate({required this.succes, required this.message});
  @override
  List<Object> get props => [message, succes];
}
