import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:perpustakaan/models/book.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

class ApiBook with ChangeNotifier {
  // List<Book> _allBook = [];

  // List<Book> get allBook => _allBook;

  // int get jumlahBook => _allBook.length;

  // Book selectById(String id) =>
  //   _allBook.firstWhere((element) => element.id == id);

  Future<Map<String, dynamic>> fetchData() async {
    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    await Future.delayed(Duration(seconds: 2));
    // Membuat header dengan menyertakan token akses
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/books/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Book> getBookById(int id) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/books/$id/'));

    if (response.statusCode == 200) {
      Book jsonResponse = Book.fromJson(jsonDecode(response.body));
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Book>> searchBookByTitle(String judul) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/filter-book/judul/?search=$judul'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Book> result =
          jsonResponse.map((data) => Book.fromJson(data)).toList();
      return result;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Book>> BookByCategory(String namacategory) async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8000/api/filter-book/category/?categorybook__namaCategory=$namacategory'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Book> result =
          jsonResponse.map((data) => Book.fromJson(data)).toList();
      return result;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
