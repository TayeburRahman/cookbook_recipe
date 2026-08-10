import 'dart:convert';

class RecipeBox {
  int? statusCode;
  bool? success;
  String? message;
  RecipeBoxDataMap? data;

  RecipeBox({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory RecipeBox.fromRawJson(String str) =>
      RecipeBox.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeBox.fromJson(Map<String, dynamic> json) => RecipeBox(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : RecipeBoxDataMap.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class RecipeBoxDataMap {
  List<RecipeBoxData>? result;
  Meta? meta;

  RecipeBoxDataMap({
    this.result,
    this.meta,
  });

  factory RecipeBoxDataMap.fromRawJson(String str) =>
      RecipeBoxDataMap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeBoxDataMap.fromJson(Map<String, dynamic> json) =>
      RecipeBoxDataMap(
        result: json["result"] == null
            ? []
            : List<RecipeBoxData>.from(
                json["result"]!.map((x) => RecipeBoxData.fromJson(x))),
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

class RecipeBoxData {
  String? id;
  String? image;
  String? name;
  List<String>? category;
  // CategorySection? category;
  String? oils;
  int? servingSize;
  int? prepTime;
  double? ratting;
  List<dynamic>? favorites;
  bool? favorite;

  RecipeBoxData({
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

  factory RecipeBoxData.fromRawJson(String str) =>
      RecipeBoxData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeBoxData.fromJson(Map<String, dynamic> json) => RecipeBoxData(
        id: json["_id"],
        image: json["image"],
        name: json["name"],
        category: json["category"] == null
            ? []
            : List<String>.from(json["category"]!.map((x) => x)),
        // category: json["category"] == null
        //     ? null
        //     : CategorySection.fromJson(json["category"]),
        oils: json["oils"],
        servingSize: json["serving_size"],
        prepTime: json["prep_time"],
        ratting: (json["ratting"] as num?)?.toDouble(),
        favorites: json["favorites"] == null
            ? []
            : List<dynamic>.from(json["favorites"]!.map((x) => x)),
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
