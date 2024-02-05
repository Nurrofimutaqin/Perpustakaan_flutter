import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perpustakaan/models/peminjaman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPeminjaman extends StatefulWidget {
  late final Peminjaman detail;
  DetailPeminjaman({required this.detail});

  @override
  State<DetailPeminjaman> createState() => _DetailPeminjamanState();
}

class _DetailPeminjamanState extends State<DetailPeminjaman> {
    final TextEditingController tglKembalicontroller = TextEditingController();
    bool ischecked = false;

  Future<void> Returned(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:8000/api/book-loans/${widget.detail.id}/';

    // Mengambil token akses dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    // Membuat header dengan menyertakan token akses
    final Map<String, String> token = {
      'Authorization': 'Bearer $accessToken',
    };
    // Mengambil data dari kontroler teks
    final String tanggal_kembali = tglKembalicontroller.text;
    final String status = ischecked.toString();

    final Map<String, dynamic> data = {
      'status' : status,
      'tanggal_kembali': tanggal_kembali,

    };

    // Mengirim permintaan POST ke server
    final http.Response response = await http.put(
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
          content: Text('Returned successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Returned failed'),
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
        title: Text('data'),
      ),
      body: Center(
        child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.pink.withOpacity(0.3)),
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text('Nama Peminjam:')),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text(widget.detail.member_nama))
                  ],
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text('Judul Buku:')),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text(widget.detail.buku_judul))
                  ],
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text('Tanggal Pinjam')),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Text(widget.detail.tanggal_kembali))
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      ischecked = !ischecked; // Toggle the ischecked state
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Status'),
                      Checkbox(
                        value: ischecked,
                        onChanged: (value) {
                          setState(() {
                            ischecked = value ?? false;
                            print(ischecked); // Update ischecked based on value
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'Tanggal Pengembalian',
                        border: OutlineInputBorder()),
                  ),
                ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                 Returned(context);
              },
              child: Text('Pengembalian'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.purpleAccent),
            ),
              ],
            )),
      ),
    );
  }
}
