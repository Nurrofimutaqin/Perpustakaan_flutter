import 'package:flutter/foundation.dart';

class CategoryBook {
  final String namaCategory;
  final int? id;

  CategoryBook(
      {this.id,
      required this.namaCategory});
  factory CategoryBook.fromJson(Map<String, dynamic> json) {
    return CategoryBook(
        id: json['id'],
        namaCategory: json['namaCategory'],);
  }
}
