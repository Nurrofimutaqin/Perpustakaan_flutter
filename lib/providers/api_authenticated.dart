import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout() async {
  try {
    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';

    // Mengirim permintaan logout ke API
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/logout/'), // Ganti dengan URL logout API Anda
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Memeriksa status response
    if (response.statusCode == 200) {
      // Logout berhasil, hapus token akses dari SharedPreferences
      await prefs.clear();
      print("berhasil");
    } else {
      // Terjadi kesalahan saat logout
      print('Error during logout: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}