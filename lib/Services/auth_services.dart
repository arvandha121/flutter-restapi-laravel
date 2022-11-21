import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart';

class AuthServices {
  static Future<http.Response> register(
    String name,
    String email,
    String password,
  ) async {
    Map data = {
      "name": "",
      "email": email,
      "password": password,
      "device_name": "handphone",
    };

    var body = json.encode(data);
    var url = Uri.parse(baseUrl + 'auth/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> login(
    String email,
    String password,
  ) async {
    Map data = {
      "email": email,
      "password": password,
      "device_name": "android",
    };

    var body = json.encode(data);
    var url = Uri.parse(baseUrl + 'auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }
}
