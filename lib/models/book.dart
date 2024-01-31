import 'package:flutter/foundation.dart';

class Book {
  final String judul, penerbit, penulis, cover;
  final int id, tahun_terbit, categorybook;

  Book(
      {required this.id,
      required this.judul,
      required this.penerbit,
      required this.penulis,
      required this.categorybook,
      required this.tahun_terbit,
      required this.cover});
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        id: json['id'],
        judul: json['judul'],
        penerbit: json['penerbit'],
        penulis: json['penulis'],
        categorybook: json['categorybook'],
        tahun_terbit: json['tahun_terbit'],
        cover: json['cover']);
  }
}
