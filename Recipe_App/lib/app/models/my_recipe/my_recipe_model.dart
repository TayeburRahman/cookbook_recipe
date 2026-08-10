import 'dart:convert';

class MyRecipeModel {
  dynamic statusCode;
  bool? success;
  String? message;
  List<MyRecipeList>? data;

  MyRecipeModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory MyRecipeModel.fromRawJson(String str) =>
      MyRecipeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyRecipeModel.fromJson(Map<String, dynamic> json) => MyRecipeModel(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MyRecipeList>.from(
                json["data"]!.map((x) => MyRecipeList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MyRecipeList {
  String? id;
  String? creator;
  String? image;
  String? name;
  List<String>? ingredients;
  String? instructions;
  Nutritional? nutritional;
  List<String>? category;
  String? holidayRecipes;
  String? oils;
  String? servingTemperature;
  String? flavor;
  String? weightAndMuscle;
  String? wholeFoodType;
  dynamic servingSize;
  dynamic prepTime;
  List<String>? recipeTips;
  bool? kidApproved;
  bool? noWeekendPrep;
  dynamic ratting;
  dynamic v;

  MyRecipeList({
    this.id,
    this.creator,
    this.image,
    this.name,
    this.ingredients,
    this.instructions,
    this.nutritional,
    this.category,
    this.holidayRecipes,
    this.oils,
    this.servingTemperature,
    this.flavor,
    this.weightAndMuscle,
    this.wholeFoodType,
    this.servingSize,
    this.prepTime,
    this.recipeTips,
    this.kidApproved,
    this.noWeekendPrep,
    this.ratting,
    this.v,
  });

  factory MyRecipeList.fromRawJson(String str) =>
      MyRecipeList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyRecipeList.fromJson(Map<String, dynamic> json) => MyRecipeList(
        id: json["_id"],
        creator: json["creator"],
        image: json["image"],
        name: json["name"],
        ingredients: json["ingredients"] == null
            ? []
            : List<String>.from(json["ingredients"]!.map((x) => x)),
        instructions: json["instructions"],
        nutritional: json["nutritional"] == null
            ? null
            : Nutritional.fromJson(json["nutritional"]),
        category: json["category"] == null
            ? []
            : List<String>.from(json["category"]!.map((x) => x)),
        holidayRecipes: json["holiday_recipes"],
        oils: json["oils"],
        servingTemperature: json["serving_temperature"],
        flavor: json["flavor"],
        weightAndMuscle: json["weight_and_muscle"],
        wholeFoodType: json["whole_food_type"],
        servingSize: json["serving_size"],
        prepTime: json["prep_time"],
        recipeTips: json["recipe_tips"] == null
            ? []
            : json["recipe_tips"] is String
                ? [json["recipe_tips"] as String]
                : List<String>.from(
                    json["recipe_tips"].map((x) => x.toString())),
        kidApproved: json["kid_approved"],
        noWeekendPrep: json["no_weekend_prep"],
        ratting: json["ratting"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "creator": creator,
        "image": image,
        "name": name,
        "ingredients": ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x)),
        "instructions": instructions,
        "nutritional": nutritional?.toJson(),
        "category": category,
        "holiday_recipes": holidayRecipes,
        "oils": oils,
        "serving_temperature": servingTemperature,
        "flavor": flavor,
        "weight_and_muscle": weightAndMuscle,
        "whole_food_type": wholeFoodType,
        "serving_size": servingSize,
        "prep_time": prepTime,
        "recipe_tips": recipeTips == null
            ? []
            : List<dynamic>.from(recipeTips!.map((x) => x)),
        "kid_approved": kidApproved,
        "no_weekend_prep": noWeekendPrep,
        "ratting": ratting,
        "__v": v,
      };
}

class Nutritional {
  dynamic calories;
  dynamic protein;
  dynamic carbs;
  dynamic fat;
  dynamic fiber;
  String? id;

  Nutritional({
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
    this.id,
  });

  factory Nutritional.fromRawJson(String str) =>
      Nutritional.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Nutritional.fromJson(Map<String, dynamic> json) => Nutritional(
        calories: json["calories"],
        protein: json["protein"],
        carbs: json["carbs"],
        fat: json["fat"],
        fiber: json["fiber"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "calories": calories,
        "protein": protein,
        "carbs": carbs,
        "fat": fat,
        "fiber": fiber,
        "_id": id,
      };
}
