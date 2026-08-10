import 'dart:convert';

class RecipeDetailsModel {
  int? statusCode;
  bool? success;
  String? message;
  DetailsData? data;

  RecipeDetailsModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory RecipeDetailsModel.fromRawJson(String str) =>
      RecipeDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeDetailsModel.fromJson(Map<String, dynamic> json) =>
      RecipeDetailsModel(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : DetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class DetailsData {
  String? id;
  String? creator;
  String? image;
  String? name;
  List<String>? ingredients;
  List<String>? instructions;
  // String? instructions;
  Nutritional? nutritional;
  List<String>? category;
  // CategorySection? category;
  String? holidayRecipes;
  String? oils;
  String? servingTemperature;
  String? flavor;
  String? weightAndMuscle;
  String? wholeFoodType;
  int? servingSize;
  int? prepTime;
  bool? kidApproved;
  bool? noWeekendPrep;
  double? ratting;
  List<dynamic>? favorites;
  List<String>? recipeTips;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<ScoreReview>? scoreReview;

  DetailsData({
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
    this.kidApproved,
    this.noWeekendPrep,
    this.ratting,
    this.favorites,
    this.recipeTips,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.scoreReview,
  });

  factory DetailsData.fromRawJson(String str) =>
      DetailsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailsData.fromJson(Map<String, dynamic> json) => DetailsData(
        id: json["_id"],
        creator: json["creator"],
        image: json["image"],
        name: json["name"],
        ingredients: json["ingredients"] == null
            ? []
            : List<String>.from(json["ingredients"]!.map((x) => x)),
        instructions: json["instructions"] == null
            ? [] // Handle null
            : json["instructions"] is String
                ? [
                    json["instructions"] as String
                  ] // Convert single String to List
                : List<String>.from(json["instructions"]
                    .map((x) => x.toString())), // Parse List
        // instructions: json["instructions"],
        nutritional: json["nutritional"] == null
            ? null
            : Nutritional.fromJson(json["nutritional"]),
        // category: json["category"] == null
        //     ? null
        //     : CategorySection.fromJson(json["category"]),
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
        kidApproved: json["kid_approved"],
        noWeekendPrep: json["no_weekend_prep"],
        ratting: json["ratting"]?.toDouble(),
        favorites: json["favorites"] == null
            ? []
            : List<dynamic>.from(json["favorites"]!.map((x) => x)),
        recipeTips: json["recipe_tips"] == null
            ? []
            : json["recipe_tips"] is String
                ? [json["recipe_tips"] as String]
                : List<String>.from(json["recipe_tips"].map((x) => x.toString())),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        scoreReview: json["scoreReview"] == null
            ? []
            : List<ScoreReview>.from(
                json["scoreReview"]!.map((x) => ScoreReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "creator": creator,
        "image": image,
        "name": name,
        "ingredients": ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x)),
        "instructions": instructions == null
            ? []
            : List<dynamic>.from(instructions!.map((x) => x)),
        // "instructions": instructions,
        "nutritional": nutritional?.toJson(),
        "category": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x)),
        "holiday_recipes": holidayRecipes,
        "oils": oils,
        "serving_temperature": servingTemperature,
        "flavor": flavor,
        "weight_and_muscle": weightAndMuscle,
        "whole_food_type": wholeFoodType,
        "serving_size": servingSize,
        "prep_time": prepTime,
        "kid_approved": kidApproved,
        "no_weekend_prep": noWeekendPrep,
        "ratting": ratting,
        "favorites": favorites == null
            ? []
            : List<dynamic>.from(favorites!.map((x) => x)),
        "recipe_tips": recipeTips == null
            ? []
            : List<dynamic>.from(recipeTips!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "scoreReview": scoreReview == null
            ? []
            : List<dynamic>.from(scoreReview!.map((x) => x.toJson())),
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

class ScoreReview {
  UserId? userId;
  double? ratting;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  ScoreReview({
    this.userId,
    this.ratting,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory ScoreReview.fromRawJson(String str) =>
      ScoreReview.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScoreReview.fromJson(Map<String, dynamic> json) => ScoreReview(
        userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
        ratting: (json["ratting"] as num?)?.toDouble(),
        id: json["_id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId?.toJson(),
        "ratting": ratting,
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
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

// import 'dart:convert';
//
// class RecipeDetailsModel {
//   int? statusCode;
//   bool? success;
//   String? message;
//   DetailsData? data;
//
//   RecipeDetailsModel({
//     this.statusCode,
//     this.success,
//     this.message,
//     this.data,
//   });
//
//   factory RecipeDetailsModel.fromRawJson(String str) => RecipeDetailsModel.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory RecipeDetailsModel.fromJson(Map<String, dynamic> json) => RecipeDetailsModel(
//     statusCode: json["statusCode"],
//     success: json["success"],
//     message: json["message"],
//     data: json["data"] == null ? null : DetailsData.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "statusCode": statusCode,
//     "success": success,
//     "message": message,
//     "data": data?.toJson(),
//   };
// }
//
// class DetailsData {
//   String? id;
//   String? creator;
//   String? image;
//   String? recipeTips;
//   String? name;
//   List<String>? ingredients;
//   String? instructions;
//   Nutritional? nutritional;
//   String? category;
//   String? holidayRecipes;
//   String? oils;
//   String? servingTemperature;
//   String? flavor;
//   String? weightAndMuscle;
//   String? wholeFoodType;
//   dynamic servingSize;
//   int? prepTime;
//   bool? kidApproved;
//   bool? noWeekendPrep;
//   double? ratting;
//   List<dynamic>? favorites;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? v;
//
//   DetailsData({
//     this.id,
//     this.creator,
//     this.image,
//     this.name,
//     this.recipeTips,
//     this.ingredients,
//     this.instructions,
//     this.nutritional,
//     this.category,
//     this.holidayRecipes,
//     this.oils,
//     this.servingTemperature,
//     this.flavor,
//     this.weightAndMuscle,
//     this.wholeFoodType,
//     this.servingSize,
//     this.prepTime,
//     this.kidApproved,
//     this.noWeekendPrep,
//     this.ratting,
//     this.favorites,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });
//
//   factory DetailsData.fromRawJson(String str) => DetailsData.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory DetailsData.fromJson(Map<String, dynamic> json) => DetailsData(
//     id: json["_id"],
//     creator: json["creator"],
//     image: json["image"],
//     name: json["name"],
//     recipeTips: json["recipe_tips"],
//     ingredients: json["ingredients"] == null ? [] : List<String>.from(json["ingredients"]!.map((x) => x)),
//     instructions: json["instructions"],
//     nutritional: json["nutritional"] == null ? null : Nutritional.fromJson(json["nutritional"]),
//     category: json["category"],
//     holidayRecipes: json["holiday_recipes"],
//     oils: json["oils"],
//     servingTemperature: json["serving_temperature"],
//     flavor: json["flavor"],
//     weightAndMuscle: json["weight_and_muscle"],
//     wholeFoodType: json["whole_food_type"],
//     servingSize: json["serving_size"],
//     prepTime: json["prep_time"],
//     kidApproved: json["kid_approved"],
//     noWeekendPrep: json["no_weekend_prep"],
//     ratting: (json["ratting"] as num?)?.toDouble(),
//     favorites: json["favorites"] == null ? [] : List<dynamic>.from(json["favorites"]!.map((x) => x)),
//     createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//     updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "creator": creator,
//     "image": image,
//     "name": name,
//     "recipe_tips": recipeTips,
//     "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x)),
//     "instructions": instructions,
//     "nutritional": nutritional?.toJson(),
//     "category": category,
//     "holiday_recipes": holidayRecipes,
//     "oils": oils,
//     "serving_temperature": servingTemperature,
//     "flavor": flavor,
//     "weight_and_muscle": weightAndMuscle,
//     "whole_food_type": wholeFoodType,
//     "serving_size": servingSize,
//     "prep_time": prepTime,
//     "kid_approved": kidApproved,
//     "no_weekend_prep": noWeekendPrep,
//     "ratting": ratting,
//     "favorites": favorites == null ? [] : List<dynamic>.from(favorites!.map((x) => x)),
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "__v": v,
//   };
// }
//
// class Nutritional {
//   int? calories;
//   int? protein;
//   int? carbs;
//   int? fat;
//   int? fiber;
//   String? id;
//
//   Nutritional({
//     this.calories,
//     this.protein,
//     this.carbs,
//     this.fat,
//     this.fiber,
//     this.id,
//   });
//
//   factory Nutritional.fromRawJson(String str) => Nutritional.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Nutritional.fromJson(Map<String, dynamic> json) => Nutritional(
//     calories: json["calories"],
//     protein: json["protein"],
//     carbs: json["carbs"],
//     fat: json["fat"],
//     fiber: json["fiber"],
//     id: json["_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "calories": calories,
//     "protein": protein,
//     "carbs": carbs,
//     "fat": fat,
//     "fiber": fiber,
//     "_id": id,
//   };
// }
