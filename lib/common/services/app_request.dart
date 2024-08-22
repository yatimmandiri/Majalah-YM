import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:d_method/d_method.dart';
import 'package:magazine/core/error/exceptions.dart';

class AppRequest {
  static Future<Map?> get(String url, {Map<String, String>? headers}) async {
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      DMethod.printTitle('try $url', response.body);

      switch (response.statusCode) {
        case 200:
          Map responseBody = jsonDecode(response.body);
          return responseBody;
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
      DMethod.printTitle('catch', e.toString());
      return null;
    }
  }

  static Future<dynamic> getD(String url,
      {Map<String, String>? headers}) async {
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      DMethod.printTitle('try $url', response.body);

      dynamic responseBody = jsonDecode(response.body);

      return responseBody;
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
      return null;
    }
  }

  static Future<dynamic> post(String url, Object? body,
      {Map<String, String>? headers}) async {
    try {
      http.Response response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      DMethod.printTitle('try $url', response.body);

      dynamic responseBody = jsonDecode(response.body);

      // print(response.statusCode);
      return responseBody;
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
      return null;
    }
  }
}
