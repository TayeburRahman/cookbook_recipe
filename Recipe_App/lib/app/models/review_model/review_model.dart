import 'dart:convert';

class ReviewModel {
  int? statusCode;
  bool? success;
  String? message;
  List<ReviewList>? data;

  ReviewModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory ReviewModel.fromRawJson(String str) => ReviewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ReviewList>.from(json["data"]!.map((x) => ReviewList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ReviewList {
  String? id;
  UserId? userId;
  String? recipeId;
  double? ratting;
  String? feedback;
  int? v;

  ReviewList({
    this.id,
    this.userId,
    this.recipeId,
    this.ratting,
    this.feedback,
    this.v,
  });

  factory ReviewList.fromRawJson(String str) => ReviewList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReviewList.fromJson(Map<String, dynamic> json) => ReviewList(
    id: json["_id"],
    userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
    recipeId: json["recipeId"],
    ratting: (json["ratting"] as num?)?.toDouble(),
    feedback: json["feedback"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId?.toJson(),
    "recipeId": recipeId,
    "ratting": ratting,
    "feedback": feedback,
    "__v": v,
  };
}

class UserId {
  String? id;
  String? name;
  String? email;
  String? profileImage;

  UserId({
    this.id,
    this.name,
    this.email,
    this.profileImage,
  });

  factory UserId.fromRawJson(String str) => UserId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "profile_image": profileImage,
  };
}
