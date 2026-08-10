import 'dart:convert';

class WeekendPrepModel {
  int? statusCode;
  bool? success;
  String? message;
  WeekendPrepData? data;

  WeekendPrepModel({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory WeekendPrepModel.fromRawJson(String str) =>
      WeekendPrepModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeekendPrepModel.fromJson(Map<String, dynamic> json) =>
      WeekendPrepModel(
        statusCode: json["statusCode"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : WeekendPrepData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class WeekendPrepData {
  List<PrepSection>? sections;
  List<SpeedPrep>? speedPrep;
  List<String>? prepNotes;

  WeekendPrepData({
    this.sections,
    this.speedPrep,
    this.prepNotes,
  });

  factory WeekendPrepData.fromJson(Map<String, dynamic> json) =>
      WeekendPrepData(
        sections: json["sections"] == null
            ? []
            : List<PrepSection>.from(
                json["sections"]!.map((x) => PrepSection.fromJson(x))),
        speedPrep: json["speed_prep"] == null
            ? []
            : List<SpeedPrep>.from(
                json["speed_prep"]!.map((x) => SpeedPrep.fromJson(x))),
        prepNotes: json["prep_notes"] == null
            ? []
            : List<String>.from(json["prep_notes"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "sections": sections == null
            ? []
            : List<dynamic>.from(sections!.map((x) => x.toJson())),
        "speed_prep": speedPrep == null
            ? []
            : List<dynamic>.from(speedPrep!.map((x) => x.toJson())),
        "prep_notes": prepNotes == null
            ? []
            : List<dynamic>.from(prepNotes!.map((x) => x)),
      };
}

class PrepSection {
  String? title;
  List<PrepItem>? items;

  PrepSection({
    this.title,
    this.items,
  });

  factory PrepSection.fromJson(Map<String, dynamic> json) => PrepSection(
        title: json["title"],
        items: json["items"] == null
            ? []
            : List<PrepItem>.from(
                json["items"]!.map((x) => PrepItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class PrepItem {
  String? name;
  String? amount;
  String? instruction;
  String? storage;
  String? usedIn;

  PrepItem({
    this.name,
    this.amount,
    this.instruction,
    this.storage,
    this.usedIn,
  });

  factory PrepItem.fromJson(Map<String, dynamic> json) => PrepItem(
        name: json["name"],
        amount: json["amount"],
        instruction: json["instruction"],
        storage: json["storage"],
        usedIn: json["usedIn"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
        "instruction": instruction,
        "storage": storage,
        "usedIn": usedIn,
      };
}

class SpeedPrep {
  String? ingredient;
  List<SpeedPrepStep>? steps;

  SpeedPrep({
    this.ingredient,
    this.steps,
  });

  factory SpeedPrep.fromJson(Map<String, dynamic> json) => SpeedPrep(
        ingredient: json["ingredient"],
        steps: json["steps"] == null
            ? []
            : List<SpeedPrepStep>.from(
                json["steps"]!.map((x) => SpeedPrepStep.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ingredient": ingredient,
        "steps": steps == null
            ? []
            : List<dynamic>.from(steps!.map((x) => x.toJson())),
      };
}

class SpeedPrepStep {
  String? id;
  String? text;
  bool? isDone;
  bool isLoading;

  SpeedPrepStep({
    this.id,
    this.text,
    this.isDone,
    this.isLoading = false,
  });

  factory SpeedPrepStep.fromJson(Map<String, dynamic> json) => SpeedPrepStep(
        id: json["_id"] ?? json["id"],
        text: json["text"],
        isDone: json["isDone"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "isDone": isDone,
      };
}
