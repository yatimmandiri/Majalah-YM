// To parse this JSON data, do
import 'dart:convert';

import 'package:magazine/features/auth/data/model/user_model.dart';
import 'package:magazine/features/magazine/data/model/cat_magazine_model.dart';
import 'package:magazine/features/magazine/data/model/comment_model.dart';

MagazineModel? magazineModelFromJson(String str) =>
    MagazineModel.fromJson(json.decode(str));

String magazineModelToJson(MagazineModel? data) => json.encode(data!.toJson());

class MagazineModel {
  MagazineModel({
    this.status,
    this.message,
    this.data,
  });

  final bool? status;
  final String? message;
  // final Data? data;
  final List<MagazineItem>? data;

  factory MagazineModel.fromJson(Map<String, dynamic> json) => MagazineModel(
        status: json["status"],
        message: json["message"],
        data:
            // json["data"]
            json["data"] == null
                ? null
                : List<MagazineItem>.from(
                    json["data"].map((x) => MagazineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data":
            // data
            data == null
                ? null
                : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Data {
  Data({
    this.data,
    this.pagination,
  });

  final List<MagazineItem?>? data;
  final Map<String, dynamic>? pagination;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<MagazineItem?>.from(
                json["data"]!.map((x) => MagazineItem.fromJson(x))),
        pagination: json["pagination"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x!.toJson())),
        "pagination": pagination,
      };
}

class MagazineItem {
  MagazineItem({
    this.id,
    this.name,
    this.slug,
    this.dateRelease,
    this.cover,
    this.pdf,
    this.description,
    this.likes,
    required this.relationship,
    required this.favorites,
    this.comments,
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? dateRelease;
  final String? cover;
  final String? pdf;
  final String? description;
  final int? likes;
  final List<CatMagazineItem>? relationship;
  final List<UserItem>? favorites;
  final List<CommentItem>? comments;

  factory MagazineItem.fromJson(Map<String, dynamic> json) => MagazineItem(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        dateRelease: json["date_release"],
        cover: json["cover"],
        pdf: json["pdf"],
        description: json["description"],
        likes: json["likes"],
        relationship: (json['relationship']?['categories'] as List<dynamic>?)
            ?.map((catJson) =>
                CatMagazineItem.fromJson(catJson as Map<String, dynamic>))
            .toList(),
        favorites: (json['relationship']?['favorites'] as List<dynamic>?)
            ?.map(
                (catJson) => UserItem.fromJson(catJson as Map<String, dynamic>))
            .toList(),
        comments: (json['relationship']?['comments'] as List<dynamic>?)
            ?.map((catJson) =>
                CommentItem.fromJson(catJson as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "date_release": dateRelease,
        "cover": cover,
        "pdf": pdf,
        "description": description,
        "likes": likes,
        "relationship": {
          'categories':
              relationship?.map((category) => category.toJson()).toList(),
          'favorites': favorites?.map((favor) => favor.toJson()).toList(),
          'comments': comments?.map((comment) => comment.toJson()).toList(),
        },
      };

  int getYear() {
    if (dateRelease == null) return 0;
    DateTime date = DateTime.parse(dateRelease!);
    return date.year;
  }
}

// class Relationship {
//   List<CatMagazineItem> categories;

//   Relationship({required this.categories});

//   factory Relationship.fromJson(Map<String, dynamic> json) {
//     var list = json['categories'] as List;
//     List<CatMagazineItem> catList =
//         list.map((i) => CatMagazineItem.fromJson(i)).toList();
//     return Relationship(categories: catList);
//   }
// }
