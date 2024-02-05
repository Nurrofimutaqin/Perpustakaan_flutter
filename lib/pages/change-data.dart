import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perpustakaan/models/user.dart';
import 'package:perpustakaan/providers/api_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeData extends StatefulWidget {
  late final User user;
  ChangeData({super.key, required this.user});

  @override
  State<ChangeData> createState() => _ChangeDataState();
}

class _ChangeDataState extends State<ChangeData> {
  ApiUser UserApi = ApiUser();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data
    firstNameController = TextEditingController(text: widget.user.first_name);
    lastNameController = TextEditingController(text: widget.user.last_name);
    emailController = TextEditingController(text: widget.user.email);
    usernameController = TextEditingController(text: widget.user.username);
  }

  Future<void> changedatauser(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:8000/api/change-data/member/';

    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    // Membuat header dengan menyertakan token akses
    final Map<String, String> token = {
      'Authorization': 'Bearer $accessToken',
    };
    // Mengambil data dari kontroler teks
    final String first_name = firstNameController.text;
    final String last_name = lastNameController.text;
    final String email = emailController.text;
    final String username = usernameController.text;

    // Membuat payload data
    final Map<String, String> data = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'username': username,
    };

    // Mengirim permintaan put ke server
    final http.Response response = await http.put(
      Uri.parse(apiUrl),
      headers: token,
      body: data,
    );

    // Memeriksa status response
    if (response.statusCode == 200) {
      // Data berhasil ditambahkan

      setState(() {
        UserApi.userDetail();
      });
      print('Data berhasil ditambahkan');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('change data successfully'),
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
        title: Text('Change Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                  labelText: 'Firts Name', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                  labelText: 'Last Name', border: OutlineInputBorder()),
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
                  labelText: 'Username', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                changedatauser(context);
              },
              child: Text('Change Data'),
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
