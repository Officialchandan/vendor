// To parse this JSON data, do
//
//     final VideoPlayerResponse = VideoPlayerResponseFromMap(jsonString);

import 'dart:convert';

class VideoPlayerResponse {
  VideoPlayerResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  List<VideoPlayerData>? data;

  factory VideoPlayerResponse.fromJson(String str) => VideoPlayerResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VideoPlayerResponse.fromMap(Map<String, dynamic> json) => VideoPlayerResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<VideoPlayerData>.from(json["data"].map((x) => VideoPlayerData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class VideoPlayerData {
  VideoPlayerData({
    required this.id,
    required this.vendorType,
    required this.title,
    required this.url,
    required this.description,
    required this.videoId,
    required this.image,
  });

  int id;
  int vendorType;
  String title;
  String url;
  String description;
  String image;
  String videoId;

  factory VideoPlayerData.fromJson(String str) => VideoPlayerData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VideoPlayerData.fromMap(Map<String, dynamic> json) => VideoPlayerData(
        id: json["id"] == null ? null : json["id"],
        vendorType: json["vendor_type"] == null ? null : json["vendor_type"],
        title: json["title"] == null ? "" : json["title"].toString(),
        url: json["url"] == null ? "" : json["url"].toString(),
        description: json["description"] == null ? "" : json["description"].toString(),
        image: json["image"] == null ? "" : json["image"].toString(),
        videoId: json["video_id"] == null ? "" : json["video_id"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "vendor_type": vendorType == null ? null : vendorType,
        "title": title == null ? null : title,
        "url": url == null ? null : url,
        "description": description == null ? null : description,
        "image": image == null ? null : image,
        "video_id": videoId == null ? null : videoId,
      };
}
