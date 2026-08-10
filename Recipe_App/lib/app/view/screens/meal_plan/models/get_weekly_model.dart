import 'dart:convert';

class GetWeeklyModel {
  int? statusCode;
  bool? success;
  String? message;
  WeeklyModelData? data;

  GetWeeklyModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory GetWeeklyModel.fromRawJson(String str) => GetWeeklyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetWeeklyModel.fromJson(Map<String, dynamic> json) => GetWeeklyModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : WeeklyModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class WeeklyModelData {
  bool? status;
  List<Plan>? plans;

  WeeklyModelData({
    this.status,
    this.plans,
  });

  factory WeeklyModelData.fromRawJson(String str) => WeeklyModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeeklyModelData.fromJson(Map<String, dynamic> json) => WeeklyModelData(
    status: json["status"],
    plans: json["plans"] == null ? [] : List<Plan>.from(json["plans"]!.map((x) => Plan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "plans": plans == null ? [] : List<dynamic>.from(plans!.map((x) => x.toJson())),
  };
}

class Plan {
  String? id;
  String? user;
  DateTime? startDate;
  DateTime? endDate;
  String? types;
  DateTime? createdAt;
  int? v;
  String? weekName;

  Plan({
    this.id,
    this.user,
    this.startDate,
    this.endDate,
    this.types,
    this.createdAt,
    this.v,
    this.weekName,
  });

  factory Plan.fromRawJson(String str) => Plan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["_id"],
    user: json["user"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    types: json["types"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    v: json["__v"],
    weekName: json["week_name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "types": types,
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
    "week_name": weekName,
  };
}
