// To parse this JSON data, d
import 'dart:convert';

UserModel? userModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel? data) => json.encode(data!.toJson());

class UserModel {
  UserModel({
    this.status,
    this.message,
    this.data,
  });

  final bool? status;
  final String? message;
  final UserItem? data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"],
        message: json["message"],
        data: json['data'] == null ? null : UserItem.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

// class UserItem {
//   final String? id;
//   final String? displayName;
//   final String? email;
//   final String? photoUrl;

//   UserItem({this.id, this.displayName, this.email, this.photoUrl});

//   factory UserItem.fromGoogleUser(GoogleSignInAccount account) {
//     return UserItem(
//       id: account.id,
//       displayName: account.displayName,
//       email: account.email,
//       photoUrl: account.photoUrl,
//     );
//   }
// }

class UserItem {
  UserItem({
    this.id,
    this.displayName,
    this.name,
    this.kodeUser,
    this.email,
    this.handphone,
    this.photoUrl,
  });

  final int? id;
  final String? kodeUser;
  final String? displayName;
  final String? name;
  final String? email;
  final String? handphone;
  final String? photoUrl;

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        id: json["id"],
        kodeUser: json["kode_user"],
        displayName: json["displayName"],
        name: json["name"],
        email: json["email"],
        handphone: json["handphone"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_user": kodeUser,
        "displayName": displayName,
        "name": name,
        "email": email,
        "handphone": handphone,
        "photoUrl": photoUrl,
      };
}
