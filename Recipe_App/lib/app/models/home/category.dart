import 'dart:convert';

class CategoryModel {
  int? statusCode;
  bool? success;
  String? message;
  CategoryData? data;

  CategoryModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory CategoryModel.fromRawJson(String str) =>
      CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : CategoryData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class CategoryData {
  List<Result>? result;
  Meta? meta;

  CategoryData({
    this.result,
    this.meta,
  });

  factory CategoryData.fromRawJson(String str) =>
      CategoryData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
        totalPage: json["totalPage"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
        "totalPage": totalPage,
      };
}

class Result {
  String? id;
  String? image;
  String? name;
  List<String>? category;
  // CategorySection? category;
  String? oils;
  int? servingSize;
  int? prepTime;
  double? ratting;
  List<String>? favorites;
  bool? favorite;

  Result({
    this.id,
    this.image,
    this.name,
    this.category,
    this.oils,
    this.servingSize,
    this.prepTime,
    this.ratting,
    this.favorites,
    this.favorite,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["_id"],
        image: json["image"],
        name: json["name"],
        // category: json["category"] == null
        //     ? null
        //     : CategorySection.fromJson(json["category"]),
        category: json["category"] == null
            ? []
            : List<String>.from(json["category"]!.map((x) => x)),
        oils: json["oils"],
        servingSize: json["serving_size"],
        prepTime: json["prep_time"],
        ratting: json["ratting"]?.toDouble(),
        favorites: json["favorites"] == null
            ? []
            : List<String>.from(json["favorites"]!.map((x) => x)),
        favorite: json["favorite"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
        "name": name,
        "category": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x)),
        "oils": oils,
        "serving_size": servingSize,
        "prep_time": prepTime,
        "ratting": ratting,
        "favorites": favorites == null
            ? []
            : List<dynamic>.from(favorites!.map((x) => x)),
        "favorite": favorite,
      };
}

class CategorySection {
  String? id;
  String? name;

  CategorySection({
    this.id,
    this.name,
  });

  factory CategorySection.fromRawJson(String str) =>
      CategorySection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategorySection.fromJson(Map<String, dynamic> json) =>
      CategorySection(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
