import 'dart:convert';

class CategoryModelNew {
  String? id;
  String? name;
  String? slug;
  String? image;

  CategoryModelNew({
    this.id,
    this.name,
    this.slug,
    this.image,
  });

  factory CategoryModelNew.fromRawJson(String str) =>
      CategoryModelNew.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModelNew.fromJson(Map<String, dynamic> json) =>
      CategoryModelNew(
        id: json["_id"],
        name: json["name"],
        slug: json["slug"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "slug": slug,
        "image": image,
      };
}
