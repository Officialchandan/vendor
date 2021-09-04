import 'dart:io';

class ProductVariantModel {
  String option = "";
  String size = "";
  String purchasePrice = "";
  String mrp = "";
  String sellingPrice = "";
  int stock = 0;
  List<File> productImages = [];

  ProductVariantModel(
      {this.option = "", this.purchasePrice = "", this.size = "", this.mrp = "", this.sellingPrice = "", this.stock = 0});

  @override
  String toString() {
    return 'ProductVariantModel{option: $option,size: $size, purchasePrice: $purchasePrice, mrp: $mrp, sellingPrice: $sellingPrice, stock: $stock, productImages: $productImages}';
  }
}
