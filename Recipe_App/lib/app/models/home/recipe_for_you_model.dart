import 'dart:convert';

class RecipeForYouModel {
  int? statusCode;
  bool? success;
  String? message;
  List<RecipeForYouList>? data;

  RecipeForYouModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory RecipeForYouModel.fromRawJson(String str) => RecipeForYouModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeForYouModel.fromJson(Map<String, dynamic> json) => RecipeForYouModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<RecipeForYouList>.from(json["data"]!.map((x) => RecipeForYouList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class RecipeForYouList {
  String? id;
  String? image;
  String? name;
  List<String>? category;
  String? oils;
  int? servingSize;
  int? prepTime;
  double? ratting;
  List<dynamic>? favorites;

  RecipeForYouList({
    this.id,
    this.image,
    this.name,
    this.category,
    this.oils,
    this.servingSize,
    this.prepTime,
    this.ratting,
    this.favorites,
  });

  factory RecipeForYouList.fromRawJson(String str) => RecipeForYouList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeForYouList.fromJson(Map<String, dynamic> json) => RecipeForYouList(
    id: json["_id"],
    image: json["image"],
    name: json["name"],
    category: json["category"] == null ? [] : List<String>.from(json["category"]!.map((x) => x)),
    oils: json["oils"],
    servingSize: json["serving_size"],
    prepTime: json["prep_time"],
    ratting: (json["ratting"] as num?)?.toDouble(),
    favorites: json["favorites"] == null ? [] : List<dynamic>.from(json["favorites"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "name": name,
    "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
    "oils": oils,
    "serving_size": servingSize,
    "prep_time": prepTime,
    "ratting": ratting,
    "favorites": favorites == null ? [] : List<dynamic>.from(favorites!.map((x) => x)),
  };
}
