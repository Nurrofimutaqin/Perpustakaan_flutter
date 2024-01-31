import 'package:flutter/material.dart';
import 'package:perpustakaan/pages/book_bycategory.dart';

import '../models/category.dart';
import '../providers/api_books.dart';
import '../providers/api_category.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.CategoryApi,
    required this.BookApi,
  });

  final ApiCategory CategoryApi;
  final ApiBook BookApi;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: CategoryApi.GetCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var category in snapshot.data!)
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      color: Colors.pinkAccent.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: GestureDetector(
                          onTap: () async {
                            var namacategory = category['namaCategory'];
                            var selectedcategory =
                                await BookApi.BookByCategory(namacategory);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookByCategoryPage(
                                      books: selectedcategory,
                                      nama: CategoryBook(
                                          namaCategory: namacategory))),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(category['namaCategory']),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.pink.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
        });
  }
}
