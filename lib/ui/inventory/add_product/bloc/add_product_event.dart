import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AddProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectImageEvent extends AddProductEvent {
  final BuildContext context;

  SelectImageEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class ShowOnlineShopEvent extends AddProductEvent {
  final bool online;

  ShowOnlineShopEvent({required this.online});

  @override
  List<Object?> get props => [online];
}
