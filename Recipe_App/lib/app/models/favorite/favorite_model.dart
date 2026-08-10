import 'dart:convert';

class FavoriteModel {
  int? statusCode;
  bool? success;
  String? message;
  Data? data;

  FavoriteModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory FavoriteModel.fromRawJson(String str) =>
      FavoriteModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<FavoritesRecipeData>? recipes;

  Data({
    this.recipes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        recipes: json["recipes"] == null
            ? []
            : List<FavoritesRecipeData>.from(
                json["recipes"]!.map((x) => FavoritesRecipeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "recipes": recipes == null
            ? []
            : List<dynamic>.from(recipes!.map((x) => x.toJson())),
      };
}

class FavoritesRecipeData {
  String? id;
  String? image;
  String? name;
  List<String>? category;
  String? oils;
  int? servingSize;
  int? prepTime;
  double? ratting;
  bool? favorite;

  FavoritesRecipeData({
    this.id,
    this.image,
    this.name,
    this.category,
    this.oils,
    this.servingSize,
    this.prepTime,
    this.ratting,
    this.favorite,
  });

  factory FavoritesRecipeData.fromJson(Map<String, dynamic> json) =>
      FavoritesRecipeData(
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
        "favorite": favorite,
      };
}
