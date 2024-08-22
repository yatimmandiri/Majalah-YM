import 'package:magazine/config/env.dart';

class Endpoint {
  static final String api = "$baseURL/api/v1";

  // User
  static final cbGoogleId = "$baseURL/api/auth/google/callback";
  static final profile = "$baseURL/api/user";
  static final getUser = "$api/users";
  static final logout = "$baseURL/api/logout";

  //Storage
  static final storage = "$baseURL/storage";

  //magazine
  static final magazines = "$api/magazines";
  static final likes = "$api/magazines/likes";
  static final comment = "$api/magazines/comments";
  static final magazineFav = "$api/magazines/favorites";
  static final catMagazines = "$api/categories-magazines";

  //Blog & News
  static final blog = "https://yatimmandiri.org/blog/wp-json/ymapi/v1/posts";
  static final news = "https://yatimmandiri.org/news/wp-json/ymapi/v1/posts";
}
