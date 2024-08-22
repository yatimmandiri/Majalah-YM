
import 'package:http/http.dart' as http;
import 'package:d_method/d_method.dart';
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/core/error/exceptions.dart';
import 'package:magazine/features/auth/data/model/user_model.dart';

class AuthService {
  // Method untuk mendapatkan profil pengguna
  Future<UserModel?> fetchUserProfile(String token) async {
    String url = Endpoint.profile;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // print(response.body.toString());
        return userModelFromJson(response.body);
      } else {
        print('Failed to load profile: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  static Future<UserModel?> fetchUser(String token, int userId) async {
    String url = '${Endpoint.getUser}/${userId.toString()}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      DMethod.printTitle('try $url', response.body);
      switch (response.statusCode) {
        case 200:
          var data = userModelFromJson(response.body);
          return data;
        case 404:
          throw NotFoundException();
        case 500:
        case 502:
        case 503:
        case 504:
          throw ServerException();
        default:
          throw UnknownException();
      }
    } catch (e) {
      print('Error fetching : $e');
      return null;
    }
  }
}
