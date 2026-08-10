import 'dart:convert';

class SubscriptionModel {
  int? statusCode;
  bool? success;
  String? message;
  List<SubscriptionList>? data;

  SubscriptionModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory SubscriptionModel.fromRawJson(String str) => SubscriptionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SubscriptionList>.from(json["data"]!.map((x) => SubscriptionList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SubscriptionList {
  String? id;
  String? name;
  String? duration;
  int? fee;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  SubscriptionList({
    this.id,
    this.name,
    this.duration,
    this.fee,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory SubscriptionList.fromRawJson(String str) => SubscriptionList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionList.fromJson(Map<String, dynamic> json) => SubscriptionList(
    id: json["_id"],
    name: json["name"],
    duration: json["duration"],
    fee: json["fee"],
    description: json["description"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "duration": duration,
    "fee": fee,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
