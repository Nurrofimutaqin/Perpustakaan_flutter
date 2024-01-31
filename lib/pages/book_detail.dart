import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perpustakaan/models/book.dart';
import 'package:perpustakaan/providers/api_loans.dart';
import 'package:shared_preferences/shared_preferences.dart';



class BookDetailScreen extends StatelessWidget {
  late final Book book;
   final TextEditingController tanggal_kembalicontroller= TextEditingController();

  BookDetailScreen({required this.book});

  // Declare a field that holds the Todo.
  // late final Book bookId;
//  Future<void> pinjam(BuildContext context) async {
//     try {
//       await peminjaman.Bookloans(
//         tanggal_kembali: tanggal_kembali.text, id: book.id,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Change data successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to change user data. Please try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       print('Error changing user data: $e');
//     }
//   }
  Future<void> bookloan(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:8000/api/member/book-loan-by-buku/${book.id}';

    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    // Membuat header dengan menyertakan token akses
    final Map<String, String> token = {
      'Authorization': 'Bearer $accessToken',
    };
    // Mengambil data dari kontroler teks
    final String tanggal_kembali = tanggal_kembalicontroller.text;

    // Membuat payload data
    final Map<String, String> data = {
      'tanggal_kembali': tanggal_kembali,
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
          content: Text('Book Loan successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Masukan Tanggal kembali (yy-mm-dd)'),
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
        title: Text(book.judul),
      ),
      body: ListView(children: [
        Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                book.cover,
                height: 500,
                width: 250,
              ),
              Text('Judul: ${book.judul}'),
              Text('Penerbit: ${book.penerbit}'),
              Text('Penulis: ${book.penulis}'),
              Text('Tahun Terbit: ${book.tahun_terbit.toString()}'),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: tanggal_kembalicontroller,
                      decoration: InputDecoration(
                          labelText: 'Tanggal Kembali',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: ()=> bookloan(context),
                      child: Text('Pinjam'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.purpleAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
