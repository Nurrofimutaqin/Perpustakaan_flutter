import 'package:flutter/material.dart';
import 'package:perpustakaan/models/peminjaman.dart';

class DetailPeminjaman extends StatelessWidget {

  late final Peminjaman detail;
    DetailPeminjaman({required this.detail});
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
            color: Colors.pink.withOpacity(0.3)
          ),
          margin: EdgeInsets.all(10),
            child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Nama Peminjam:')
                  ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(detail.member_nama)
                  )
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Judul Buku:')
                  ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(detail.buku_judul)
                  )
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Tanggal Pinjam')
                  ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('peminjaman.tanggal_pinjam')
                  )
              ],
            ),
          ],
        )),
      ),
    );
  }
}
