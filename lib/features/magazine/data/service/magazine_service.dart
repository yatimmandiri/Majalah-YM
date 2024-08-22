import 'package:http/http.dart' as http;
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/core/error/exceptions.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';

class MagazineService {
  // Method untuk mendapatkan profil pengguna
  static Future<bool> fetchFavMagazine(String token, magazineId) async {
    String url = '${Endpoint.magazineFav}/$magazineId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          // print(response.body.toString());
          return true;
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
      return false;
    }
  }

  static Future<bool> fetchLike(int magazineId) async {
    String url = '${Endpoint.likes}/$magazineId';

    try {
      final response = await http.post(Uri.parse(url));

      switch (response.statusCode) {
        case 200:
          print('success');
          return true;
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
      return false;
    }
  }

  static Future<MagazineModel?> fetchMagazine() async {
    String url = Endpoint.magazines;

    try {
      final response = await http.get(Uri.parse(url));

      switch (response.statusCode) {
        case 200:
          return magazineModelFromJson(response.body);
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
