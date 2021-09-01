import 'dart:io';

import 'package:equatable/equatable.dart';

class AddProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddProductInitialState extends AddProductState {}

class ImageLoadingState extends AddProductState {}

class SelectImageState extends AddProductState {
  final File image;

  SelectImageState({required this.image});

  @override
  List<Object?> get props => [image];
}
