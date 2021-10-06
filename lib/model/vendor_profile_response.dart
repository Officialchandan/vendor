// To parse this JSON data, do
//
//     final vendorDetailResponse = vendorDetailResponseFromMap(jsonString);

import 'dart:convert';

class VendorDetailResponse {
  VendorDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<VendorDetailData>? data;

  factory VendorDetailResponse.fromJson(String str) =>
      VendorDetailResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VendorDetailResponse.fromMap(Map<String, dynamic> json) =>
      VendorDetailResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<VendorDetailData>.from(
                json["data"].map((x) => VendorDetailData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
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
  });

  int id;
  String uniqueId;
  String shopName;
  String ownerName;
  String ownerMobile;
  int addedBy;
  String commission;
  int offer;

  factory VendorDetailData.fromJson(String str) =>
      VendorDetailData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VendorDetailData.fromMap(Map<String, dynamic> json) =>
      VendorDetailData(
        id: json["id"] == null ? null : json["id"],
        uniqueId: json["unique_id"] == null ? null : json["unique_id"],
        shopName: json["shop_name"] == null ? null : json["shop_name"],
        ownerName: json["owner_name"] == null ? null : json["owner_name"],
        ownerMobile: json["owner_mobile"] == null ? null : json["owner_mobile"],
        addedBy: json["added_by"] == null ? null : json["added_by"],
        commission: json["commission"] == null ? null : json["commission"],
        offer: json["offer"] == null ? null : json["offer"],
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
      };
}
