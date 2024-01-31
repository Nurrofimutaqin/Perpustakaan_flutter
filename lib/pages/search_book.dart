import 'package:flutter/material.dart';
import 'package:perpustakaan/models/book.dart';
import 'package:perpustakaan/pages/book_detail.dart';
import '../providers/api_books.dart';

class SearchBook extends StatefulWidget {
  const SearchBook({super.key});

  @override
  State<SearchBook> createState() => _SearchBookState();
}

class _SearchBookState extends State<SearchBook> {
  TextEditingController _searchController = TextEditingController();
  List<Book> searchResults = [];
  Future<void> searchBooks() async {
    ApiBook BookApi = ApiBook();
    String judul = _searchController.text;

    try {
      List<Book> result = await BookApi.searchBookByTitle(judul);
      setState(() {
        searchResults = result;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  ApiBook BookApi = ApiBook();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Search Book by Title",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.pink,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Search Book',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    searchBooks();
                  },
                ),
                suffixIconColor: Colors.white,
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: searchResults.length == 0
                  ? Center(
                      child: Text(
                        'Result Not Found',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        var book = searchResults[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.pink.withOpacity(0.3)),
                            child: ListTile(
                              title: Text(book.judul),
                              subtitle: Text(book.penulis),
                              leading: Image.network(book.cover),
                              trailing: Text(book.tahun_terbit.toString()),
                              onTap: () async {
                                var bookId = book.id;
                                var selectedBook =
                                    await BookApi.getBookById(bookId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookDetailScreen(book: selectedBook)),
                                );
                                // Tambahkan logika untuk menangani saat buku dipilih di sini
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
