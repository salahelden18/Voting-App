import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/http_exception.dart';
import '../models/user_model.dart';

class HomeProvider with ChangeNotifier {
  UserModel? user;

  List<UserModel>? _canidates;

  List<UserModel> get candidates {
    return [..._canidates!];
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<Map<String, dynamic>> getUserData() async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('token');
      final token = await getToken();

      final url = Uri.parse('http://10.0.2.2:3000/api/v1/users/getMe');

      http.Response response = await http.get(url, headers: {
        'auth_token': token,
      });

      final responseData = json.decode(response.body);

      if (responseData['status'] == 'fail') {
        throw HttpException(responseData['message']);
      }

      notifyListeners();
      return {
        'name': responseData['data']['user']['name'],
        'email': responseData['data']['user']['email'],
        'department': responseData['data']['user']['department'],
        'gpa': responseData['data']['user']['gpa'],
        'grade': responseData['data']['user']['grade'],
        'isCandidate': responseData['data']['user']['isCandidate'],
        'previousRes': responseData['data']['user']['previousRes'],
        'repReansons': responseData['data']['user']['repReansons'],
        'voted': responseData['data']['user']['voted'],
        'votes': responseData['data']['user']['votes']
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<List> getCanidateList() async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('token');
      final token = await getToken();

      final url = Uri.parse('http://10.0.2.2:3000/api/v1/users/candidateList');

      http.Response response = await http.get(url, headers: {
        'auth_token': token,
      });

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final decodedData = responseData['data']['users'] as List<dynamic>;
      print(decodedData);
      notifyListeners();
      return decodedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(
      double gpa, int grade, String previousRes, String repReansons) async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('token');
      final token = await getToken();

      final url = Uri.parse('http://10.0.2.2:3000/api/v1/users/updateUser');
      http.Response response = await http.patch(url,
          body: json.encode({
            'gpa': gpa,
            'grade': grade,
            'previousRes': previousRes,
            'repReansons': repReansons,
            'isCandidate': true,
            'votes': 0,
          }),
          headers: {
            'auth_token': token,
            'Content-Type': 'application/json; charset=UTF-8',
          });

      final decodedResponse = json.decode(response.body);

      if (decodedResponse['status'] == 'fail') {
        print('error');
        throw HttpException(decodedResponse['message']);
      }

      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateUserVote(String candidateId, int votes) async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('token');
      final token = await getToken();

      final url = Uri.parse('http://10.0.2.2:3000/api/v1/users/updateUser');

      http.Response currentUser = await http.patch(url,
          body: json.encode({'voted': true}),
          headers: {
            'auth_token': token,
            'Content-Type': 'application/json; charset=UTF-8'
          });

      final decodedCurrentUser = jsonDecode(currentUser.body);

      if (decodedCurrentUser['status'] == 'fail') {
        throw HttpException(decodedCurrentUser['message']);
      }

      final url2 = Uri.parse(
          'http://10.0.2.2:3000/api/v1/users/updateUserById/$candidateId');

      http.Response candidateUser = await http.patch(url2,
          body: json.encode({
            'votes': votes + 1,
          }),
          headers: {
            'auth_token': token,
            'Content-Type': 'application/json; charset=UTF-8'
          });

      final decodedCandidateUser = jsonDecode(candidateUser.body);
      if (decodedCandidateUser['status'] == 'fail') {
        throw HttpException(decodedCandidateUser['message']);
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
