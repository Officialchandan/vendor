import 'package:equatable/equatable.dart';
import 'package:vendor/model/product_model.dart';

class EditProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditProductInitialState extends EditProductState {
  @override
  List<Object?> get props => [];
}

class DeleteProductImageState extends EditProductState {
  final ProductImage image;

  DeleteProductImageState({required this.image});

  @override
  List<Object?> get props => [image];
}

class UpdateProductState extends EditProductState {
  UpdateProductState();

  @override
  List<Object?> get props => [];
}
