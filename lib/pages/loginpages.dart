import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perpustakaan/pages/register.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> loginUser(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:8000/api/login/';

    // Mengambil data dari kontroler teks
    final String username = usernameController.text;
    final String password = passwordController.text;

    // Membuat payload data untuk permintaan login
    final Map<String, String> data = {
      'username': username,
      'password': password,
    };

    // Mengirim permintaan POST untuk mendapatkan token
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    // Memeriksa status response
    if (response.statusCode == 200) {
      // Login berhasil, simpan token
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['access'];
      final String role = responseData['user']['role'];

      print('Token: $token');
      print('Token: $role');
      // Simpan token ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', token);
      prefs.setString('role', role);

      // Navigasi ke halaman home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Menampilkan SnackBar jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Gagal. Periksa kembali username dan password.'),
          backgroundColor: Colors.red,
        ),
      );
      // Login gagal, tampilkan pesan kesalahan
      print('Login Gagal. Status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('LOGIN')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 350,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.pink.withOpacity(0.5)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: _obscureText,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => loginUser(context),
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Row(
                        children: [
                          Text('Belum Punya Akun?   '),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                              );
                            },
                            child: Text(
                              'Regirter',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
