import 'dart:convert';

class WeeklyMealPlanModel {
  dynamic statusCode;
  bool? success;
  String? message;
  WeeklyMealPlanData? data;

  WeeklyMealPlanModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory WeeklyMealPlanModel.fromRawJson(String str) =>
      WeeklyMealPlanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeeklyMealPlanModel.fromJson(Map<String, dynamic> json) =>
      WeeklyMealPlanModel(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : WeeklyMealPlanData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class WeeklyMealPlanData {
  String? id;
  String? user;
  DateTime? startDate;
  DateTime? endDate;
  List<Datum>? data;
  String? types;
  DateTime? createdAt;
  dynamic v;

  WeeklyMealPlanData({
    this.id,
    this.user,
    this.startDate,
    this.endDate,
    this.data,
    this.types,
    this.createdAt,
    this.v,
  });

  factory WeeklyMealPlanData.fromRawJson(String str) =>
      WeeklyMealPlanData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeeklyMealPlanData.fromJson(Map<String, dynamic> json) =>
      WeeklyMealPlanData(
        id: json["_id"],
        user: json["user"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        types: json["types"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "types": types,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
      };
}

class Datum {
  String? day;
  List<RecipeElement>? recipes;
  String? id;
  DayNutritional? nutritionalTotals;

  Datum({
    this.day,
    this.recipes,
    this.id,
    this.nutritionalTotals,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        day: json["day"],
        recipes: json["recipes"] == null
            ? []
            : List<RecipeElement>.from(
                json["recipes"]!.map((x) => RecipeElement.fromJson(x))),
        id: json["_id"],
        nutritionalTotals: json["nutritionalTotals"] == null
            ? null
            : DayNutritional.fromJson(json["nutritionalTotals"]),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "recipes": recipes == null
            ? []
            : List<dynamic>.from(recipes!.map((x) => x.toJson())),
        "_id": id,
        "nutritionalTotals": nutritionalTotals?.toJson(),
      };
}

class DayNutritional {
  dynamic calories;
  dynamic protein;
  dynamic carbs;
  dynamic fat;
  dynamic fiber;
  String? id;

  DayNutritional({
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
    this.id,
  });

  factory DayNutritional.fromRawJson(String str) =>
      DayNutritional.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DayNutritional.fromJson(Map<String, dynamic> json) => DayNutritional(
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

class RecipeElement {
  RecipeRecipe? recipe;
  String? id;

  RecipeElement({
    this.recipe,
    this.id,
  });

  factory RecipeElement.fromRawJson(String str) =>
      RecipeElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeElement.fromJson(Map<String, dynamic> json) => RecipeElement(
        recipe: json["recipe"] == null
            ? null
            : RecipeRecipe.fromJson(json["recipe"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "recipe": recipe?.toJson(),
        "_id": id,
      };
}

class RecipeRecipe {
  String? id;
  String? image;
  String? name;
  DayNutritional? nutritional;
  List<String>? category;
  double? ratting;
  String? prep;

  RecipeRecipe({
    this.id,
    this.image,
    this.name,
    this.nutritional,
    this.category,
    this.ratting,
    this.prep,
  });

  factory RecipeRecipe.fromRawJson(String str) =>
      RecipeRecipe.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeRecipe.fromJson(Map<String, dynamic> json) => RecipeRecipe(
        id: json["_id"],
        image: json["image"],
        name: json["name"],
        nutritional: json["nutritional"] == null
            ? null
            : DayNutritional.fromJson(json["nutritional"]),
        category: json["category"] == null
            ? []
            : List<String>.from(json["category"]!.map((x) => x.toString())),
        ratting: json["ratting"]?.toDouble(),
        prep: json["prep"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
        "name": name,
        "nutritional": nutritional?.toJson(),
        "category": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x)),
        "ratting": ratting,
        "prep": prep,
      };
}

// import 'dart:convert';
//
// class WeeklyMealPlanModel {
//   int? statusCode;
//   bool? success;
//   String? message;
//   WeeklyMealPlanData? data;
//
//   WeeklyMealPlanModel({
//     this.statusCode,
//     this.success,
//     this.message,
//     this.data,
//   });
//
//   factory WeeklyMealPlanModel.fromRawJson(String str) => WeeklyMealPlanModel.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory WeeklyMealPlanModel.fromJson(Map<String, dynamic> json) => WeeklyMealPlanModel(
//     statusCode: json["statusCode"],
//     success: json["success"],
//     message: json["message"],
//     data: json["data"] == null ? null : WeeklyMealPlanData.fromJson(json["data"]),
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
// class WeeklyMealPlanData {
//   String? id;
//   String? user;
//   DateTime? startDate;
//   DateTime? endDate;
//   List<Datum>? data;
//   String? types;
//   DateTime? createdAt;
//   int? v;
//
//   WeeklyMealPlanData({
//     this.id,
//     this.user,
//     this.startDate,
//     this.endDate,
//     this.data,
//     this.types,
//     this.createdAt,
//     this.v,
//   });
//
//   factory WeeklyMealPlanData.fromRawJson(String str) => WeeklyMealPlanData.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory WeeklyMealPlanData.fromJson(Map<String, dynamic> json) => WeeklyMealPlanData(
//     id: json["_id"],
//     user: json["user"],
//     startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
//     endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
//     data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
//     types: json["types"],
//     createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//     v: json["__v"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "user": user,
//     "startDate": startDate?.toIso8601String(),
//     "endDate": endDate?.toIso8601String(),
//     "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//     "types": types,
//     "createdAt": createdAt?.toIso8601String(),
//     "__v": v,
//   };
// }
//
// class Datum {
//   String? day;
//   List<RecipeElement>? recipes;
//   String? id;
//   DayNutritional? dayNutritional;
//
//
//   Datum({
//     this.day,
//     this.recipes,
//     this.id,
//     this.dayNutritional
//   });
//
//   factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     day: json["day"],
//     recipes: json["recipes"] == null ? [] : List<RecipeElement>.from(json["recipes"]!.map((x) => RecipeElement.fromJson(x))),
//     id: json["_id"],
//     dayNutritional: json["dayNutritional"] == null ? null : DayNutritional.fromJson(json["dayNutritional"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "day": day,
//     "recipes": recipes == null ? [] : List<dynamic>.from(recipes!.map((x) => x.toJson())),
//     "_id": id,
//     "dayNutritional": dayNutritional?.toJson(),
//   };
// }
//
//
// class DayNutritional {
//   int? calories;
//   int? protein;
//   int? carbs;
//   int? fat;
//   int? fiber;
//   int? sugars;
//   int? saturatedFat;
//   int? sodium;
//
//   DayNutritional({
//     this.calories,
//     this.protein,
//     this.carbs,
//     this.fat,
//     this.fiber,
//     this.sugars,
//     this.saturatedFat,
//     this.sodium,
//   });
//
//   factory DayNutritional.fromRawJson(String str) => DayNutritional.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory DayNutritional.fromJson(Map<String, dynamic> json) => DayNutritional(
//     calories: json["calories"],
//     protein: json["protein"],
//     carbs: json["carbs"],
//     fat: json["fat"],
//     fiber: json["fiber"],
//     sugars: json["sugars"],
//     saturatedFat: json["saturated_fat"],
//     sodium: json["sodium"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "calories": calories,
//     "protein": protein,
//     "carbs": carbs,
//     "fat": fat,
//     "fiber": fiber,
//     "sugars": sugars,
//     "saturated_fat": saturatedFat,
//     "sodium": sodium,
//   };
// }
// class RecipeElement {
//   RecipeRecipe? recipe;
//   String? id;
//
//   RecipeElement({
//     this.recipe,
//     this.id,
//   });
//
//   factory RecipeElement.fromRawJson(String str) => RecipeElement.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory RecipeElement.fromJson(Map<String, dynamic> json) => RecipeElement(
//     recipe: json["recipe"] == null ? null : RecipeRecipe.fromJson(json["recipe"]),
//     id: json["_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "recipe": recipe?.toJson(),
//     "_id": id,
//   };
// }
//
// class RecipeRecipe {
//   String? id;
//   String? image;
//   String? name;
//   Nutritional? nutritional;
//   String? category;
//   double? ratting;
//   String? prep;
//   bool? favorite;
//
//
//   RecipeRecipe({
//     this.id,
//     this.image,
//     this.name,
//     this.nutritional,
//     this.category,
//     this.ratting,
//     this.prep,
//     this.favorite
//   });
//
//   factory RecipeRecipe.fromRawJson(String str) => RecipeRecipe.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory RecipeRecipe.fromJson(Map<String, dynamic> json) => RecipeRecipe(
//     id: json["_id"],
//     image: json["image"],
//     name: json["name"],
//     nutritional: json["nutritional"] == null ? null : Nutritional.fromJson(json["nutritional"]),
//     category: json["category"],
//     ratting: (json["ratting"] as num?)?.toDouble(),
//     prep: json["prep"],
//     favorite: json["favorite"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "image": image,
//     "name": name,
//     "nutritional": nutritional?.toJson(),
//     "category": category,
//     "ratting": ratting,
//     "prep": prep,
//     "favorite": favorite,
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
