import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> RegisterUser(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:8000/api/registration/';

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
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Gagal. Periksa kembali username dan password.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigasi ke halaman home
      Navigator.pop(context);
    } else {
      // Menampilkan SnackBar jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('regis Gagal. Periksa kembali username dan password.'),
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
        title: Text('Register'),
      ),
      body: ListView(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 500,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
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
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => RegisterUser(context),
                        child: Text('register'),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
