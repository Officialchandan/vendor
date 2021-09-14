import 'dart:io';

class ProductVariantModel {
  List<VariantOption> option = [];

  String purchasePrice = "";
  String mrp = "";
  String sellingPrice = "";
  String stock = "";
  List<File> productImages = [];

  ProductVariantModel({this.purchasePrice = "", this.mrp = "", this.sellingPrice = "", this.stock = ""});

  @override
  String toString() {
    return 'ProductVariantModel{option: $option, purchasePrice: $purchasePrice, mrp: $mrp, sellingPrice: $sellingPrice, stock: $stock, productImages: $productImages}';
  }
}

class VariantOption {
  String name = "";
  String value = "";

  VariantOption({this.name = "", this.value = ""});

  @override
  String toString() {
    return 'Option{name: $name, value: $value}';
  }
}
