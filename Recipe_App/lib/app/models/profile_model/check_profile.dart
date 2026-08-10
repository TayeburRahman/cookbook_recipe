import 'dart:convert';

class CheckProfileModel {
  int? statusCode;
  bool? success;
  String? message;
  CheckData? data;

  CheckProfileModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory CheckProfileModel.fromRawJson(String str) => CheckProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckProfileModel.fromJson(Map<String, dynamic> json) => CheckProfileModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : CheckData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class CheckData {
  bool? status;
  String? message;

  CheckData({
    this.status,
    this.message,
  });

  factory CheckData.fromRawJson(String str) => CheckData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckData.fromJson(Map<String, dynamic> json) => CheckData(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
