import 'dart:convert';

class UploadImageResponse {
  UploadImageResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<ImageData>? data;

  factory UploadImageResponse.fromJson(String str) => UploadImageResponse.fromMap(json.decode(str));

  factory UploadImageResponse.fromMap(Map<String, dynamic> json) => UploadImageResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<ImageData>.from(json["data"].map((x) => ImageData.fromMap(x))),
      );
}

class ImageData {
  ImageData({
    required this.id,
    required this.variantId,
    required this.productImage,
  });

  String id;
  String variantId;
  List<String> productImage;

  factory ImageData.fromJson(String str) => ImageData.fromMap(json.decode(str));

  factory ImageData.fromMap(Map<String, dynamic> json) => ImageData(
        id: json["id"] == null ? "" : json["id"].toString(),
        variantId: json["variant_id"] == null ? "" : json["variant_id"].toString(),
        productImage: json["product_image"] == null ? [] : List<String>.from(json["product_image"].map((x) => x)),
      );
}
