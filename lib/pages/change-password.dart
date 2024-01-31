import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatelessWidget {
  final TextEditingController oldpasswordcontroller = TextEditingController();
  final TextEditingController newpasswordcontroller = TextEditingController();

  Future<void> Changepassword(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:8000/api/change-password/';

    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    // Membuat header dengan menyertakan token akses
    final Map<String, String> token = {
      'Authorization': 'Bearer $accessToken',
    };
    // Mengambil data dari kontroler teks
    final String old_password = oldpasswordcontroller.text;
    final String new_password = newpasswordcontroller.text;

    // Membuat payload data
    final Map<String, String> data = {
      'old_password': old_password,
      'new_password': new_password,
    };

    // Mengirim permintaan POST ke server
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: token,
      body: data,
    );

    // Memeriksa status response
    if (response.statusCode == 200) {
      // Data berhasil ditambahkan
      print('Data berhasil ditambahkan');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('change password successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal. password lama tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
      // Terjadi kesalahan
      print('Terjadi kesalahan: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              obscureText: true,
              controller: oldpasswordcontroller,
              decoration: InputDecoration(
                  labelText: 'Old Password', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: newpasswordcontroller,
              decoration: InputDecoration(
                  labelText: 'New Password', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Changepassword(context),
              child: Text('Change Password'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.purpleAccent),
            ),
          ],
        ),
      ),
    );
  }
}
