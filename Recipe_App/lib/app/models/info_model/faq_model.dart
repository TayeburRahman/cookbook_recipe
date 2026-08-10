import 'dart:convert';

class FaqModel {
  int? statusCode;
  bool? success;
  String? message;
  List<FaqList>? data;

  FaqModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory FaqModel.fromRawJson(String str) => FaqModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<FaqList>.from(json["data"]!.map((x) => FaqList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FaqList {
  String? id;
  String? questions;
  String? answer;
  int? v;

  FaqList({
    this.id,
    this.questions,
    this.answer,
    this.v,
  });

  factory FaqList.fromRawJson(String str) => FaqList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FaqList.fromJson(Map<String, dynamic> json) => FaqList(
    id: json["_id"],
    questions: json["questions"],
    answer: json["answer"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "questions": questions,
    "answer": answer,
    "__v": v,
  };
}
