import 'dart:convert';

class FeaturePlanModel {
  int? statusCode;
  bool? success;
  String? message;
  List<FeaturePlanList>? data;

  FeaturePlanModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory FeaturePlanModel.fromRawJson(String str) => FeaturePlanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeaturePlanModel.fromJson(Map<String, dynamic> json) => FeaturePlanModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<FeaturePlanList>.from(json["data"]!.map((x) => FeaturePlanList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FeaturePlanList {
  String? id;
  String? user;
  String? name;
  String? types;
  DateTime? createdAt;
  int? v;

  FeaturePlanList({
    this.id,
    this.user,
    this.name,
    this.types,
    this.createdAt,
    this.v,
  });

  factory FeaturePlanList.fromRawJson(String str) => FeaturePlanList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeaturePlanList.fromJson(Map<String, dynamic> json) => FeaturePlanList(
    id: json["_id"],
    user: json["user"],
    name: json["name"],
    types: json["types"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "name": name,
    "types": types,
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
  };
}
