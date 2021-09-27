import 'package:equatable/equatable.dart';
import 'package:vendor/model/product_model.dart';

class EditProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditProductApiEvent extends EditProductEvent {
  final Map<String, dynamic> input;

  EditProductApiEvent({required this.input});

  @override
  List<Object?> get props => [input];
}

class DeleteImageEvent extends EditProductEvent {
  final ProductImage image;

  DeleteImageEvent({required this.image});

  @override
  List<Object?> get props => [image];
}
