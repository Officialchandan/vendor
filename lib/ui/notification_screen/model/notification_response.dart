import 'dart:convert';

class NotificationResponse {
  NotificationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<NotificationData>? data;

  factory NotificationResponse.fromJson(String str) =>
      NotificationResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationResponse.fromMap(Map<String, dynamic> json) =>
      NotificationResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<NotificationData>.from(
                json["data"].map((x) => NotificationData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class NotificationData {
  NotificationData({
    required this.id,
    required this.notiListId,
    required this.name,
    required this.vendorId,
    required this.isRead,
    required this.createdAt,
    required this.notificationData,
    this.notificationDataDetails,
  });

  int id;
  int notiListId;
  String name;
  int vendorId;
  int isRead;
  String createdAt;
  String notificationData;
  NotificationDataDetails? notificationDataDetails;

  factory NotificationData.fromJson(String str) =>
      NotificationData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationData.fromMap(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"] == null ? null : json["id"],
        notiListId: json["noti_list_id"] == null ? null : json["noti_list_id"],
        name: json["name"] == null ? null : json["name"],
        vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
        isRead: json["is_read"] == null ? null : json["is_read"],
        createdAt: json["created_at"] == null ? "" : json["created_at"],
        notificationData: json["notification_data"] == null
            ? null
            : json["notification_data"],
        notificationDataDetails: json["notification_data_details"] == null
            ? null
            : NotificationDataDetails.fromMap(
                json["notification_data_details"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "noti_list_id": notiListId == null ? null : notiListId,
        "name": name == null ? null : name,
        "vendor_id": vendorId == null ? null : vendorId,
        "is_read": isRead == null ? null : isRead,
        "created_at": createdAt == null ? null : createdAt,
        "notification_data": notificationData == null ? null : notificationData,
        "notification_data_details": notificationDataDetails == null
            ? []
            : notificationDataDetails!.toMap(),
      };
}

class NotificationDataDetails {
  NotificationDataDetails({
    required this.title,
    required this.body,
    this.data,
  });

  String title;
  String body;
  Details? data;

  factory NotificationDataDetails.fromJson(String str) =>
      NotificationDataDetails.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationDataDetails.fromMap(Map<String, dynamic> json) =>
      NotificationDataDetails(
        title: json["title"] == null ? null : json["title"],
        body: json["body"] == null ? null : json["body"],
        data: json["data"] == null ? null : Details.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "title": title == null ? null : title,
        "body": body == null ? null : body,
        "data": data == null ? null : data!.toMap(),
      };
}

class Details {
  Details({
    required this.mobile,
    required this.otp,
    required this.deviceToken,
  });

  String mobile;
  String otp;
  String deviceToken;

  factory Details.fromJson(String str) => Details.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Details.fromMap(Map<String, dynamic> json) => Details(
        mobile: json["mobile"] == null ? null : json["mobile"],
        otp: json["otp"] == null ? null : json["otp"],
        deviceToken: json["device_token"] == null ? null : json["device_token"],
      );

  Map<String, dynamic> toMap() => {
        "mobile": mobile == null ? null : mobile,
        "otp": otp == null ? null : otp,
        "device_token": deviceToken == null ? null : deviceToken,
      };
}
