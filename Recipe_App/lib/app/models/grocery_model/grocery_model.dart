import 'dart:convert';

import 'package:get/get.dart';

class GroceryModel {
  int? statusCode;
  bool? success;
  String? message;
  GroceryData? data;

  GroceryModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory GroceryModel.fromRawJson(String str) => GroceryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GroceryModel.fromJson(Map<String, dynamic> json) => GroceryModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : GroceryData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class GroceryData {
  String? id;
  String? user;
  List<Datum>? data;

  GroceryData({
    this.id,
    this.user,
    this.data,
  });

  factory GroceryData.fromRawJson(String str) => GroceryData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GroceryData.fromJson(Map<String, dynamic> json) => GroceryData(
    id: json["_id"],
    user: json["user"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? day;
  List<RecipeElement>? recipes;
  String? id;

  Datum({
    this.day,
    this.recipes,
    this.id,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    day: json["day"],
    recipes: json["recipes"] == null ? [] : List<RecipeElement>.from(json["recipes"]!.map((x) => RecipeElement.fromJson(x))),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "recipes": recipes == null ? [] : List<dynamic>.from(recipes!.map((x) => x.toJson())),
    "_id": id,
  };
}

class RecipeElement {
  RecipeRecipe? recipe;
  List<Ingredient>? ingredients;
  String? id;

  RecipeElement({
    this.recipe,
    this.ingredients,
    this.id,
  });

  factory RecipeElement.fromRawJson(String str) => RecipeElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeElement.fromJson(Map<String, dynamic> json) => RecipeElement(
    recipe: json["recipe"] == null ? null : RecipeRecipe.fromJson(json["recipe"]),
    ingredients: json["ingredients"] == null ? [] : List<Ingredient>.from(json["ingredients"]!.map((x) => Ingredient.fromJson(x))),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "recipe": recipe?.toJson(),
    "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
    "_id": id,
  };
}
class Ingredient {
  String? ingredient;
  RxBool buy; // RxBool
  String? id;

  RxBool isToggling = false.obs;

  // constructor এখন bool নেবে, তারপর .obs করবে
  Ingredient({
    this.ingredient,
    required bool buy,
    this.id,
  }) : buy = buy.obs;  // এখানে .obs ব্যবহার

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    ingredient: json["ingredient"],
    buy: json["buy"] ?? false,  // bool হিসেবে পাঠাচ্ছি
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "ingredient": ingredient,
    "buy": buy.value,
    "_id": id,
  };
}




class RecipeRecipe {
  String? id;
  String? image;
  String? name;
  List<String>? category;

  RecipeRecipe({
    this.id,
    this.image,
    this.name,
    this.category
  });

  factory RecipeRecipe.fromRawJson(String str) => RecipeRecipe.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeRecipe.fromJson(Map<String, dynamic> json) => RecipeRecipe(
    id: json["_id"],
    image: json["image"],
    name: json["name"],
    category: json["category"] == null ? [] : List<String>.from(json["category"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "name": name,
    "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
  };
}
