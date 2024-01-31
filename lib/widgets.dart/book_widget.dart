import 'package:flutter/material.dart';
import 'package:perpustakaan/providers/api_books.dart';

import '../pages/book_detail.dart';

class BookWidget extends StatelessWidget {
  const BookWidget({
    super.key,
    required this.BookApi,
  });

  final ApiBook BookApi;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: BookApi.fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!["results"].length,
            itemBuilder: (context, index) {
              var book = snapshot.data?['results'][index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GridTile(
                  child: GestureDetector(
                    onTap: () async {
                      var bookId = book['id'];
                      var selectedBook =
                          await BookApi.getBookById(bookId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookDetailScreen(book: selectedBook)),
                      );
                    },
                    child: Image.network(
                      book['cover'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  footer: GridTileBar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    title: Text(
                      book['judul'],
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
        }
      },
    );
  }
}

