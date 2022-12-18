import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';

class AuthServices {
  final String token = '';

  static Future<http.Response> register(
    String name,
    String email,
    String password,
    String device_name,
  ) async {
    Map data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'device_name': device_name,
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
    String device_name,
  ) async {
    Map data = {
      "email": email,
      "password": password,
      "device_name": device_name,
    };

    var body = json.encode(data);
    var url = Uri.parse(baseUrl + 'auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print('token');
    print(response.body);
    var datas = json.decode(response.body);

    _save('token', datas['token']);
    // save('name', datas['name']);
    return response;
  }

  static Future<http.Response> logout(String token) async {
    var url = Uri.parse(baseUrl + 'auth/logout');
    final body = {};
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' '$token',
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print(response.body);
    return response;
  }

  static _save(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    //const key = 'token';
    //final value = token;
    prefs.setString(key, data);
  }
}
