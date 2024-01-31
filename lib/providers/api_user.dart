import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:perpustakaan/models/peminjaman.dart';
import 'package:perpustakaan/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiUser with ChangeNotifier {
  late User _user  ;

   User get user => _user;
   
  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/member/profile/'),
        headers: headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _user = User.fromJson(jsonData);
      notifyListeners();
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>> userDetail() async {
    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    await Future.delayed(Duration(seconds: 2));
    // Membuat header dengan menyertakan token akses
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/member/profile/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> peminjaman() async {
    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    await Future.delayed(Duration(seconds: 2));
    // Membuat header dengan menyertakan token akses
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/book-loans/user/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  //   Future<List<Peminjaman>> GetDataPeminjaman() async {
  //   // Mengambil token akses dari SharedPreferences
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String accessToken = prefs.getString('access_token') ?? '';
  //   await Future.delayed(Duration(seconds: 2));
  //   // Membuat header dengan menyertakan token akses
  //   final Map<String, String> headers = {
  //     'Authorization': 'Bearer $accessToken',
  //   };
  //   final response = await http.get(
  //     Uri.parse('http://10.0.2.2:8000/api/book-loans/user/'),
  //     headers: headers,
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonResponse = jsonDecode(response.body);
  //     List<Peminjaman> result =
  //         jsonResponse.map((data) =>  Peminjaman.fromJson(data)).toList();
  //     return result;
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
  Future<User> getdatauser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    // Membuat header dengan menyertakan token akses
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/change-data/member/'),
        headers: headers);

    if (response.statusCode == 200) {
      User jsonResponse = User.fromJson(jsonDecode(response.body));
      return jsonResponse;
    } else {
      throw Exception('Failed to load data dan code ${response.statusCode}');
    }
  }
}
