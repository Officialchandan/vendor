import 'dart:convert';

class TermsResponse {
  TermsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  TermsData? data;

  factory TermsResponse.fromJson(String str) => TermsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TermsResponse.fromMap(Map<String, dynamic> json) => TermsResponse(
        success: json["success"] == null ? false : json["success"],
        message: json["message"] == null ? "" : json["message"],
        data: json["data"] == null ? null : TermsData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class TermsData {
  TermsData({
    required this.id,
    required this.termAndCondition,
    required this.ownerSign,
    required this.ownerSignature,
  });

  String id;
  String termAndCondition;
  String ownerSign;
  String ownerSignature;

  factory TermsData.fromJson(String str) => TermsData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TermsData.fromMap(Map<String, dynamic> json) => TermsData(
        id: json["id"] == null ? "" : json["id"].toString(),
        termAndCondition: json["term_and_condition"] == null ? "" : json["term_and_condition"].toString(),
        ownerSign: json["owner_sign"] == null ? "" : json["owner_sign"].toString(),
        ownerSignature: json["owner_signature"] == null ? "" : json["owner_signature"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? "" : id,
        "term_and_condition": termAndCondition == null ? "" : termAndCondition,
        "owner_sign": ownerSign == null ? "" : ownerSign,
        "owner_signature": ownerSignature == null ? "" : ownerSignature,
      };
}
