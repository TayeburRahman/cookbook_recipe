import 'dart:convert';

class BannerModel {
  int? statusCode;
  bool? success;
  String? message;
  Meta? meta;
  List<BannerList>? data;

  BannerModel({
    this.statusCode,
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory BannerModel.fromRawJson(String str) => BannerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    statusCode: json["statusCode"],
    success: json["success"],
    message: json["message"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    data: json["data"] == null ? [] : List<BannerList>.from(json["data"]!.map((x) => BannerList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "meta": meta?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BannerList {
  String? id;
  String? title;
  String? image;
  String? link;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  BannerList({
    this.id,
    this.title,
    this.image,
    this.link,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerList.fromRawJson(String str) => BannerList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerList.fromJson(Map<String, dynamic> json) => BannerList(
    id: json["_id"],
    title: json["title"],
    image: json["image"],
    link: json["link"],
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "image": image,
    "link": link,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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
