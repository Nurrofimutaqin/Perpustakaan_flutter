import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ApiCategory with ChangeNotifier {


    Future<List<dynamic>> GetCategory() async {
    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    // Membuat header dengan menyertakan token akses
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/categorys/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

}