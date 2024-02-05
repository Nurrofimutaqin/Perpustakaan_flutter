import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perpustakaan/models/book.dart';
import 'package:shared_preferences/shared_preferences.dart';



class BookDetailScreen extends StatelessWidget {
  late final Book book;
  //  final TextEditingController tanggal_kembalicontroller= TextEditingController();

  BookDetailScreen({required this.book});

  Future<void> bookloan(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:8000/api/member/book-loan-by-buku/${book.id}';

    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    // Membuat header dengan menyertakan token akses
    final Map<String, String> token = {
      'Authorization': 'Bearer $accessToken',
    };
    // // Mengambil data dari kontroler teks
    // final String tanggal_kembali = tanggal_kembalicontroller.text;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    // Jika pengguna memilih tanggal, kirim permintaan pinjam buku
    if (pickedDate != null) {
      // Konversi tanggal ke format "YYYY-MM-DD"
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    // Membuat payload data
      final Map<String, String> data = {
        'tanggal_kembali': formattedDate,
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
                    // TextField(
                    //   controller: tanggal_kembalicontroller,
                    //   decoration: InputDecoration(
                    //       labelText: 'Tanggal Kembali',
                    //       border: OutlineInputBorder()),
                    // ),
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
