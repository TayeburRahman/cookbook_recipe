import 'dart:convert';
import 'package:get/get.dart';

class GroceryAdviceModel {
  int? statusCode;
  bool? success;
  String? message;
  GroceryAdviceData? data;

  GroceryAdviceModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory GroceryAdviceModel.fromRawJson(String str) =>
      GroceryAdviceModel.fromJson(json.decode(str));

  factory GroceryAdviceModel.fromJson(Map<String, dynamic> json) =>
      GroceryAdviceModel(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : GroceryAdviceData.fromJson(json["data"]),
      );
}

class GroceryAdviceData {
  String? planTitle;
  String? duration;
  List<AdviceDay>? days;
  List<GroceryDepartment>? completeGroceryList;

  GroceryAdviceData({
    this.planTitle,
    this.duration,
    this.days,
    this.completeGroceryList,
  });

  factory GroceryAdviceData.fromJson(Map<String, dynamic> json) =>
      GroceryAdviceData(
        planTitle: json["plan_title"],
        duration: json["duration"],
        days: json["days"] == null
            ? []
            : List<AdviceDay>.from(
                json["days"].map((x) => AdviceDay.fromJson(x)),
              ),
        completeGroceryList: json["complete_grocery_list"] == null
            ? []
            : List<GroceryDepartment>.from(
                json["complete_grocery_list"].map(
                  (x) => GroceryDepartment.fromJson(x),
                ),
              ),
      );
}

class AdviceDay {
  int? day;
  List<AdviceMeal>? meals;

  AdviceDay({this.day, this.meals});

  factory AdviceDay.fromJson(Map<String, dynamic> json) => AdviceDay(
        day: json["day"],
        meals: json["meals"] == null
            ? []
            : List<AdviceMeal>.from(
                json["meals"].map((x) => AdviceMeal.fromJson(x)),
              ),
      );
}

class AdviceMeal {
  String? category;
  String? recipeName;
  List<String>? ingredients;
  List<String>? instructions;

  AdviceMeal({
    this.category,
    this.recipeName,
    this.ingredients,
    this.instructions,
  });

  factory AdviceMeal.fromJson(Map<String, dynamic> json) => AdviceMeal(
        category: json["category"],
        recipeName: json["recipe_name"],
        ingredients: json["ingredients"] == null
            ? []
            : List<String>.from(json["ingredients"]),
        instructions: json["instructions"] == null
            ? []
            : List<String>.from(json["instructions"]),
      );
}

class GroceryDepartment {
  String? department;
  List<GroceryItem>? items;

  GroceryDepartment({this.department, this.items});

  factory GroceryDepartment.fromJson(Map<String, dynamic> json) =>
      GroceryDepartment(
        department: json["department"],
        items: json["items"] == null
            ? []
            : List<GroceryItem>.from(
                json["items"].map((x) => GroceryItem.fromJson(x)),
              ),
      );
}

class GroceryItem {
  String? name;
  String? amountToPurchase;
  RxBool isPurchased = false.obs;

  GroceryItem({this.name, this.amountToPurchase, bool? isPurchased})
      : isPurchased = (isPurchased ?? false).obs;

  factory GroceryItem.fromJson(Map<String, dynamic> json) => GroceryItem(
        name: json["name"],
        amountToPurchase: json["amount_to_purchase"] ?? json["amount"],
        isPurchased: json["isPurchased"] ?? json["is_purchased"] ?? false,
      );
}
