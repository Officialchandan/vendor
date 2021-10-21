import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:vendor/model/add_product_response.dart';
import 'package:vendor/model/product_variant.dart';
import 'package:vendor/model/upload_image_response.dart';

class AddProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddProductInitialState extends AddProductState {}

class ImageLoadingState extends AddProductState {}

class SelectImageState extends AddProductState {
  final List<File> image;

  SelectImageState({required this.image});

  @override
  List<Object?> get props => [image];
}

class ShowOnlineShopState extends AddProductState {
  final bool online;

  ShowOnlineShopState({required this.online});

  @override
  List<Object?> get props => [online];
}

class AddProductVariantState extends AddProductState {
  final List<ProductVariantModel> productVariant;

  AddProductVariantState({required this.productVariant});

  @override
  List<Object?> get props => [productVariant];
}

class UpdateProductVariantState extends AddProductState {
  final List<ProductVariantModel> productVariant;

  UpdateProductVariantState({required this.productVariant});

  @override
  List<Object?> get props => [productVariant];
}

class UpdateSingleProductVariantState extends AddProductState {
  final ProductVariantModel productVariant;
  final int index;

  UpdateSingleProductVariantState({required this.productVariant, required this.index});

  @override
  List<Object?> get props => [productVariant, index];
}

class DeleteProductVariantState extends AddProductState {
  final ProductVariantModel productVariant;

  DeleteProductVariantState({required this.productVariant});

  @override
  List<Object?> get props => [productVariant];
}

class SelectVariantOptionState extends AddProductState {
  final ProductVariantModel variant;

  SelectVariantOptionState({required this.variant});

  @override
  List<Object?> get props => [variant];
}

class AddProductSuccessState extends AddProductState {
  final ResponseData responseData;

  AddProductSuccessState({required this.responseData});

  @override
  List<Object?> get props => [responseData];
}

class AddProductFailureState extends AddProductState {
  final String message;

  AddProductFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}

class UploadImageSuccessState extends AddProductState {
  final List<ImageData> image;

  UploadImageSuccessState({required this.image});

  @override
  List<Object?> get props => [image];
}

class UploadImageFailureState extends AddProductState {
  UploadImageFailureState();

  @override
  List<Object?> get props => [];
}
