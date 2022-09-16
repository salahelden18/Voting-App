import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _token;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(
      String name, String department, String email, String password) async {
    try {
      final url = Uri.parse('http://10.0.2.2:3000/api/v1/users/signup');
      http.Response resposne = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'department': department,
            'name': name,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      final responseData = json.decode(resposne.body);
      if (responseData['status'] == 'fail') {
        throw HttpException(responseData['message']);
      }

      _token = responseData['token'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final url = Uri.parse('http://10.0.2.2:3000/api/v1/users/signin');
      http.Response resposne = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      final responseData = json.decode(resposne.body);

      if (responseData['status'] == 'fail') {
        throw HttpException(responseData['message']);
      }

      _token = responseData['token'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token!);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return false;
    }
    final token = prefs.getString('token');

    _token = token;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // Future<bool> autoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('token')) {
  //     return false;
  //   }
  //   final token = prefs.getString('token');
  //   notifyListeners();
  //   return token != null;
  // }
}
