import 'dart:convert';

class VendorDetailResponse {
  VendorDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  VendorDetailData? data;

  factory VendorDetailResponse.fromJson(String str) =>
      VendorDetailResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VendorDetailResponse.fromMap(Map<String, dynamic> json) =>
      VendorDetailResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : VendorDetailData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class VendorDetailData {
  VendorDetailData({
    required this.id,
    required this.uniqueId,
    required this.shopName,
    required this.ownerName,
    required this.ownerMobile,
    required this.addedBy,
    required this.commission,
    required this.offer,
    required this.ownerSign,
    required this.ownerIdProof,
    required this.termsAndCondition,
    this.vendorImage,
  });

  int id;
  String uniqueId;
  String shopName;
  String ownerName;
  String ownerMobile;
  int addedBy;
  String commission;
  int offer;
  String ownerSign;
  String ownerIdProof;
  String termsAndCondition;
  List<VendorImage>? vendorImage;

  factory VendorDetailData.fromJson(String str) =>
      VendorDetailData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VendorDetailData.fromMap(Map<String, dynamic> json) =>
      VendorDetailData(
        id: json["id"] == null ? 0 : json["id"],
        uniqueId: json["unique_id"] == null ? "" : json["unique_id"],
        shopName: json["shop_name"] == null ? "" : json["shop_name"],
        ownerName: json["owner_name"] == null ? "" : json["owner_name"],
        ownerMobile: json["owner_mobile"] == null ? "" : json["owner_mobile"],
        addedBy: json["added_by"] == null ? "" : json["added_by"],
        commission: json["commission"] == null ? "" : json["commission"],
        offer: json["offer"] == null ? 0 : json["offer"],
        ownerSign: json["owner_sign"] == null ? "" : json["owner_sign"],
        ownerIdProof:
            json["owner_id_proof"] == null ? "" : json["owner_id_proof"],
        termsAndCondition: json["term_and_condition"] == null
            ? ""
            : json["term_and_condition"],
        vendorImage: json["vendor_image"] == null
            ? []
            : List<VendorImage>.from(
                json["vendor_image"].map((x) => VendorImage.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "unique_id": uniqueId == null ? null : uniqueId,
        "shop_name": shopName == null ? null : shopName,
        "owner_name": ownerName == null ? null : ownerName,
        "owner_mobile": ownerMobile == null ? null : ownerMobile,
        "added_by": addedBy == null ? null : addedBy,
        "commission": commission == null ? null : commission,
        "offer": offer == null ? null : offer,
        "owner_sign": ownerSign == null ? null : ownerSign,
        "owner_id_proof": ownerIdProof == null ? null : ownerIdProof,
        "term_and_condition":
            termsAndCondition == null ? null : termsAndCondition,
        "vendor_image": vendorImage == null
            ? null
            : List<dynamic>.from(vendorImage!.map((x) => x.toMap())),
      };
}

class VendorImage {
  VendorImage({
    required this.id,
    required this.image,
  });

  int id;
  String image;

  factory VendorImage.fromJson(String str) =>
      VendorImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VendorImage.fromMap(Map<String, dynamic> json) => VendorImage(
        id: json["id"] == null ? "" : json["id"],
        image: json["image"] == null ? "" : json["image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
      };
}
