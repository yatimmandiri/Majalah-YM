import 'package:shared_preferences/shared_preferences.dart';

class Session {
  // =============================Manajemen User============================
  // static Future<bool> saveUser(User user) async{
  //   final pref = await SharedPreferences.getInstance();
  //   Map<String, dynamic> mapUser = user.toJson();
  //   String stringUser = jsonEncode(mapUser);
  //   bool success = await pref.setString('user', stringUser);
  //   if (success) {
  //     final cUser = Get.put(CUser());
  //     cUser.setData(user);
  //   }
  //   return success;
  // }

  // static Future<User> getUser() async {
  //   User user = User();
  //   final pref = await SharedPreferences.getInstance();
  //   String? stringUser = pref.getString('user');
  //   if (stringUser != null) {
  //     Map<String, dynamic> mapUser = jsonDecode(stringUser);
  //     user =User.fromJson(mapUser);
  //   }
  //   final cUser = Get.put(CUser());
  //   cUser.setData(user);
  //   return user;
  // }

  // static Future<bool> clearUser() async {
  //   final pref = await SharedPreferences.getInstance();
  //   bool success = await pref.remove('user');
  //   final cUser = Get.put(CUser());
  //   cUser.setData(User());
  //   return success;
  // }

  //============================Manajemen Token==========================

  static Future<String> saveToken(token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', token);

    return token;
  }

  static Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    // print(token);
    return token;
  }

  static Future<bool> clearToken() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('token');

    return success;
  }

//============================Manajemen photo profile==========================

  static Future<String?> saveGooglePhoto(String? url) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('googlePhoto', url ?? 'https://via.placeholder.com/100');

    return url;
  }

  static Future<String?> getGooglePhoto() async {
    final pref = await SharedPreferences.getInstance();
    String? googlePhoto = pref.getString('googlePhoto');
    // print(googlePhoto);
    return googlePhoto;
  }

  static Future<bool> clearGooglePhoto() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('googlePhoto');

    return success;
  }
}
