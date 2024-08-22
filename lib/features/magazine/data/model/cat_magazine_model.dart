// To parse this JSON data, do
import 'dart:convert';

CatMagazineModel? catMagazineModelFromJson(String str) =>
    CatMagazineModel.fromJson(json.decode(str));

String catMagazineModelToJson(CatMagazineModel? data) =>
    json.encode(data!.toJson());

class CatMagazineModel {
  CatMagazineModel({
    this.status,
    this.message,
    this.data,
  });

  final bool? status;
  final String? message;
  final List<CatMagazineItem>? data;

  factory CatMagazineModel.fromJson(Map<String, dynamic> json) =>
      CatMagazineModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<CatMagazineItem>.from(
                json["data"].map((x) => CatMagazineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CatMagazineItem {
  CatMagazineItem({
    this.id,
    this.name,
    this.relationship,
  });

  final int? id;
  final String? name;
  final List? relationship;

  factory CatMagazineItem.fromJson(Map<String, dynamic> json) =>
      CatMagazineItem(
        id: json["id"],
        name: json["name"],
        relationship: json["relationship"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "relationship": relationship,
      };
}
