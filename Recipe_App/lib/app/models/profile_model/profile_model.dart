import 'dart:convert';

class ProfileModel {
  int? statusCode;
  bool? success;
  String? message;
  ProfileData? data;

  ProfileModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory ProfileModel.fromRawJson(String str) =>
      ProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class ProfileData {
  String? id;
  AuthId? authId;
  String? name;
  String? gender;
  String? location;
  String? email;
  dynamic profileImage;
  String? phoneNumber;
  String? countryName;
  String? countryCode;
  bool? isPhoneNumberVerified;
  List<String>? mailTypes;
  List<String>? relevantDielary;
  String? helgthGoal;
  DateTime? dateOfBirth;
  int? amount;
  String? subscriptionStatus;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ProfileData({
    this.id,
    this.authId,
    this.name,
    this.location,
    this.gender,
    this.email,
    this.profileImage,
    this.phoneNumber,
    this.countryName,
    this.countryCode,
    this.isPhoneNumberVerified,
    this.mailTypes,
    this.relevantDielary,
    this.helgthGoal,
    this.dateOfBirth,
    this.amount,
    this.subscriptionStatus,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ProfileData.fromRawJson(String str) =>
      ProfileData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["_id"],
        authId: json["authId"] == null ? null : AuthId.fromJson(json["authId"]),
        name: json["name"],
        location: json["location"],
        gender: json["gender"],
        email: json["email"],
        profileImage: json["profile_image"],
        phoneNumber: json["phone_number"],
        countryName: json["country_name"],
        countryCode: json["country_code"],
        isPhoneNumberVerified: json["isPhoneNumberVerified"],
        mailTypes: json["mail_types"] == null
            ? []
            : List<String>.from(json["mail_types"]!.map((x) => x)),
        relevantDielary: json["relevant_dielary"] == null
            ? []
            : List<String>.from(json["relevant_dielary"]!.map((x) => x)),
        helgthGoal: json["helgth_goal"],
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
        amount: json["amount"],
        subscriptionStatus: json["subscription_status"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "authId": authId?.toJson(),
        "name": name,
        "location": location,
        "gender": gender,
        "email": email,
        "profile_image": profileImage,
        "phone_number": phoneNumber,
        "country_name": countryName,
        "country_code": countryCode,
        "isPhoneNumberVerified": isPhoneNumberVerified,
        "mail_types": mailTypes == null
            ? []
            : List<dynamic>.from(mailTypes!.map((x) => x)),
        "relevant_dielary": relevantDielary == null
            ? []
            : List<dynamic>.from(relevantDielary!.map((x) => x)),
        "helgth_goal": helgthGoal,
        "date_of_birth": dateOfBirth?.toIso8601String(),
        "amount": amount,
        "subscription_status": subscriptionStatus,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class AuthId {
  String? id;
  String? name;
  String? email;
  String? role;
  bool? codeVerify;
  String? activationCode;
  DateTime? expirationTime;
  bool? isBlock;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  dynamic verifyCode;
  DateTime? verifyExpire;

  AuthId({
    this.id,
    this.name,
    this.email,
    this.role,
    this.codeVerify,
    this.activationCode,
    this.expirationTime,
    this.isBlock,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.verifyCode,
    this.verifyExpire,
  });

  factory AuthId.fromRawJson(String str) => AuthId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthId.fromJson(Map<String, dynamic> json) => AuthId(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        codeVerify: json["codeVerify"],
        activationCode: json["activationCode"],
        expirationTime: json["expirationTime"] == null
            ? null
            : DateTime.parse(json["expirationTime"]),
        isBlock: json["is_block"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        verifyCode: json["verifyCode"],
        verifyExpire: json["verifyExpire"] == null
            ? null
            : DateTime.parse(json["verifyExpire"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "role": role,
        "codeVerify": codeVerify,
        "activationCode": activationCode,
        "expirationTime": expirationTime?.toIso8601String(),
        "is_block": isBlock,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "verifyCode": verifyCode,
        "verifyExpire": verifyExpire?.toIso8601String(),
      };
}
