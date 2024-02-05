import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;
  Future<void> RegisterUser(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:8000/api/registration/';

    // Mengambil data dari kontroler teks
    final String first_name = firstNameController.text;
    final String last_name = lastNameController.text;
    final String email = emailController.text;
    final String username = usernameController.text;
    final String password = passwordController.text;

    // Membuat payload data untuk permintaan login
    final Map<String, String> data = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
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
          content: Text('Registration Successfuly'),
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
          content: Text('regis Failed. Periksa kembali username dan password.'),
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
                height: 600,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.pink.withOpacity(0.5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                            labelText: 'Fisrt Name',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: 'Email', border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
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
