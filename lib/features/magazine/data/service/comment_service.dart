import 'package:http/http.dart' as http;
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/core/error/exceptions.dart';

class CommentService {
  static Future<bool> fetchComment(
      String token, int magazineId, int parentId, content) async {
    String url = '${Endpoint.comment}/$magazineId';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'magazine_id': magazineId.toString(),
          'content': content,
          'parent_id': parentId.toString(),
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
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

  static Future<bool> deleteComment(
      String token, int magazineId, int commentId) async {
    String url = '${Endpoint.comment}/$magazineId?comment_id=$commentId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
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
}
