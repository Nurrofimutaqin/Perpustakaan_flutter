import 'package:flutter/material.dart';
import 'package:perpustakaan/models/category.dart';
import 'package:perpustakaan/models/user.dart';
import 'package:perpustakaan/pages/book_bycategory.dart';
// import 'package:http/retry.dart';
import 'package:perpustakaan/pages/book_detail.dart';
import 'package:perpustakaan/pages/book_loans.dart';
import 'package:perpustakaan/pages/book_loans_near_overdue.dart';
import 'package:perpustakaan/pages/change-data.dart';
import 'package:perpustakaan/pages/change-password.dart';
import 'package:perpustakaan/pages/search_book.dart';
import 'package:perpustakaan/providers/api_authenticated.dart';
// import 'package:perpustakaan/providers/api_authenticated.dart';
import 'package:perpustakaan/providers/api_category.dart';
import 'package:perpustakaan/providers/api_user.dart';
// import '../models/book.dart';
import '../providers/api_books.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final User user;
  ApiUser UserApi = ApiUser();
  ApiBook BookApi = ApiBook();
  ApiCategory CategoryApi = ApiCategory();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Center(child: Text('Library Apps')),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  BookApi.fetchData();
                  UserApi.userDetail();
                  CategoryApi.GetCategory();
                });
              },
              icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchBook()));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder<List<dynamic>>(
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
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    var namacategory = category['namaCategory'];
                                    var selectedcategory =
                                        await BookApi.BookByCategory(
                                            namacategory);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BookByCategoryPage(
                                                  books: selectedcategory,
                                                  nama: CategoryBook(
                                                      namaCategory:
                                                          namacategory))),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    color: Colors.pink.withOpacity(0.3),
                                    child: Text(category['namaCategory']),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                }),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
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
              ),
            ),
          ],
        ),
      ),
      drawer: SizedBox(
        //membuat menu drawer
        child: Drawer(
          //membuat list,
          //list digunakan untuk melakukan scrolling jika datanya terlalu panjang
          child: ListView(
            padding: EdgeInsets.zero,
            //di dalam listview ini terdapat beberapa widget drawable
            children: [
              FutureBuilder<Map<String, dynamic>>(
                  future: UserApi.userDetail(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final user = snapshot.data;
                      return UserAccountsDrawerHeader(
                        //membuat gambar profil
                        currentAccountPicture: Image(
                            image: NetworkImage(
                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")),
                        //membuat nama akun
                        accountName: Text(user?['username']),
                        //membuat nama email
                        accountEmail: Text(user?['email']),

                        //memberikan background
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://cdn.pixabay.com/photo/2016/04/24/20/52/laundry-1350593_960_720.jpg"),
                                fit: BoxFit.cover)),
                      );
                    }
                  }),
              //membuat list menu
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Beranda"),
                onTap: () {
                setState(() {
                  BookApi.fetchData();
                  UserApi.userDetail();
                  CategoryApi.GetCategory();
                });
              },
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text("Profil"),
                onTap: () async {
                  var selectedUser = await UserApi.getdatauser();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeData(user: selectedUser)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.create),
                title: Text("Transaksi Peminjaman"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookLoans()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("Book Loans Near Overdue"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookLoansAll()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("Change Password"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () async {
                  await logout();
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
