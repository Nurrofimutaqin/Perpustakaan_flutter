import 'package:flutter/material.dart';
import 'package:perpustakaan/models/book.dart';
import 'package:perpustakaan/models/category.dart';
import 'package:perpustakaan/pages/book_detail.dart';
import 'package:perpustakaan/providers/api_books.dart';

class BookByCategoryPage extends StatelessWidget {
  final List<Book> books;
  ApiBook BookApi = ApiBook();
  final CategoryBook nama;

  BookByCategoryPage({required this.books, required this.nama});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Books by Category ${nama.namaCategory}'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: books.length,
          itemBuilder: (context, index) {
            var book = books[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GridTile(
                child: GestureDetector(
                  onTap: () async {
                    var bookId = book.id;
                    var selectedBook = await BookApi.getBookById(bookId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BookDetailScreen(book: selectedBook)),
                    );
                  },
                  child: Image.network(
                    book.cover,
                    fit: BoxFit.cover,
                  ),
                ),
                footer: GridTileBar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  title: Text(
                    book.judul,
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
        ),
      ),
    );
  }
}
