// To parse this JSON data, do
//
//     final getFreeCoinHistoryResponse = getFreeCoinHistoryResponseFromMap(jsonString);

import 'dart:convert';

class ValidateAppVersionResponse {
  ValidateAppVersionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  ValidateAppVersionData? data;

  factory ValidateAppVersionResponse.fromJson(String str) => ValidateAppVersionResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ValidateAppVersionResponse.fromMap(Map<String, dynamic> json) => ValidateAppVersionResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : ValidateAppVersionData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class ValidateAppVersionData {
  ValidateAppVersionData({
    required this.isMandatory,
    required this.appUrl,
  });

  int isMandatory;
  String appUrl;

  factory ValidateAppVersionData.fromJson(String str) => ValidateAppVersionData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ValidateAppVersionData.fromMap(Map<String, dynamic> json) => ValidateAppVersionData(
        isMandatory: json["is_mandatory"] == null ? null : json["is_mandatory"],
        appUrl: json["app_url"] == null ? null : json["app_url"],
      );

  Map<String, dynamic> toMap() => {
        "is_mandatory": isMandatory == null ? null : isMandatory,
        "app_url": appUrl == null ? null : appUrl,
      };
}
