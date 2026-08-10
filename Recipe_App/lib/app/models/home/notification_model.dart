import 'dart:convert';

class NotificationModel {
  int? statusCode;
  bool? success;
  String? message;
  List<NotificationList>? data;

  NotificationModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory NotificationModel.fromRawJson(String str) => NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<NotificationList>.from(json["data"]!.map((x) => NotificationList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}



class NotificationList {
  String? id;
  String? user;
  String? title;
  String? message;
  DateTime? createdAt;
  int? v;

  NotificationList({
    this.id,
    this.user,
    this.title,
    this.message,
    this.createdAt,
    this.v,
  });

  factory NotificationList.fromRawJson(String str) => NotificationList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
    id: json["_id"],
    user: json["user"],
    title: json["title"],
    message: json["message"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "title": title,
    "message": message,
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
  };
}
