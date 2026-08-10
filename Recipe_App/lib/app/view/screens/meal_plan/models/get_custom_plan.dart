import 'dart:convert';

class GetCustomPlan {
  int? statusCode;
  bool? success;
  String? message;
  List<CustomPlanList>? data;

  GetCustomPlan({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory GetCustomPlan.fromRawJson(String str) => GetCustomPlan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCustomPlan.fromJson(Map<String, dynamic> json) => GetCustomPlan(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<CustomPlanList>.from(json["data"]!.map((x) => CustomPlanList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CustomPlanList {
  String? id;
  String? user;
  String? name;
  String? types;
  DateTime? createdAt;
  int? v;

  CustomPlanList({
    this.id,
    this.user,
    this.name,
    this.types,
    this.createdAt,
    this.v,
  });

  factory CustomPlanList.fromRawJson(String str) => CustomPlanList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomPlanList.fromJson(Map<String, dynamic> json) => CustomPlanList(
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
