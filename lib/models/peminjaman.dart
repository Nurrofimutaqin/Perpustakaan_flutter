import 'package:flutter/foundation.dart';


class Peminjaman {
  final String tanggal_pinjam, tanggal_kembali, member_nama, buku_judul;
  final bool status;
  final int id;

  Peminjaman({required this.id, required this.tanggal_pinjam,required this.tanggal_kembali,required this.status,required this.member_nama,required this.buku_judul});
  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
        id: json['id'],
        tanggal_pinjam: json['tanggal_pinjam'].toString(),
        tanggal_kembali: json['tanggal_kembali'].toString(),
        status: json['status'],
        member_nama: json['member_nama'].toString(),
        buku_judul: json['buku_judul'].toString(),
        );
  }
}
