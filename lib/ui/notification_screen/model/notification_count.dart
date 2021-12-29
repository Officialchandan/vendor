// To parse this JSON data, do
//
//     final notificationCount = notificationCountFromMap(jsonString);

import 'dart:convert';

class NotificationCount {
  NotificationCount({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<CountData>? data;

  factory NotificationCount.fromJson(String str) =>
      NotificationCount.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationCount.fromMap(Map<String, dynamic> json) =>
      NotificationCount(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<CountData>.from(
                json["data"].map((x) => CountData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class CountData {
  CountData({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory CountData.fromJson(String str) => CountData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CountData.fromMap(Map<String, dynamic> json) => CountData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
