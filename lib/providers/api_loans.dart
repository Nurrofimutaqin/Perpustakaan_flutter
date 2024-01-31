import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:perpustakaan/models/peminjaman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loans {
  Future<List<dynamic>> LoansListNearOverdue() async {
    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    // Membuat header dengan menyertakan token akses
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/book-loans/near-overdue/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
    Future<List<dynamic>> LoansListOverdue() async {
    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    // Membuat header dengan menyertakan token akses
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/book-loans/overdue/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
    Future<Peminjaman> getPeminjamanById(int id) async {
          // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    // Membuat header dengan menyertakan token akses
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/book-loans/$id/'),
        headers: headers,
        );

    if (response.statusCode == 200) {
      Peminjaman jsonResponse = Peminjaman.fromJson(jsonDecode(response.body));
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
