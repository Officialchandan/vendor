import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/model/product_variant.dart';

class AddProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectImageEvent extends AddProductEvent {
  final BuildContext context;
  final ImageSource source;

  SelectImageEvent({required this.context, this.source = ImageSource.camera});

  @override
  List<Object?> get props => [context, source];
}

class ShowOnlineShopEvent extends AddProductEvent {
  final bool online;

  ShowOnlineShopEvent({required this.online});

  @override
  List<Object?> get props => [online];
}

class AddProductVariantEvent extends AddProductEvent {
  final List<ProductVariantModel> productVariant;
  final int listStatus;

  AddProductVariantEvent({required this.listStatus, required this.productVariant});

  @override
  List<Object?> get props => [productVariant, listStatus];
}

class UpdateProductVariantEvent extends AddProductEvent {
  final List<ProductVariantModel> productVariant;

  UpdateProductVariantEvent({required this.productVariant});

  @override
  List<Object?> get props => [productVariant];
}

class UpdateSingleProductVariantEvent extends AddProductEvent {
  final ProductVariantModel productVariant;
  final int index;

  UpdateSingleProductVariantEvent({required this.productVariant, required this.index});

  @override
  List<Object?> get props => [productVariant, index];
}

class DeleteProductVariantEvent extends AddProductEvent {
  final ProductVariantModel productVariant;

  DeleteProductVariantEvent({required this.productVariant});

  @override
  List<Object?> get props => [productVariant];
}

class SelectVariantOptionEvent extends AddProductEvent {
  final ProductVariantModel variant;

  SelectVariantOptionEvent({required this.variant});

  @override
  List<Object?> get props => [variant];
}

class AddProductApiEvent extends AddProductEvent {
  final Map<String, dynamic> input;

  AddProductApiEvent({required this.input});

  @override
  List<Object?> get props => [input];
}

class UploadImageEvent extends AddProductEvent {
  final List<File> images;
  final String variantId;
  final String productId;

  UploadImageEvent({required this.variantId, required this.images, required this.productId});

  @override
  List<Object?> get props => [images, variantId, productId];
}
