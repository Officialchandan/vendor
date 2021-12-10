import 'package:equatable/equatable.dart';

class GiftSchemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetGiftSchemeEvent extends GiftSchemeEvent {
  GetGiftSchemeEvent();
}

class GetGiftDeliverdEvent extends GiftSchemeEvent {
  final int giftid;
  GetGiftDeliverdEvent({required this.giftid});
}
