import 'package:flutter/material.dart';
import 'package:perpustakaan/pages/book_loans.dart';
import 'package:perpustakaan/pages/book_loans_near_overdue.dart';
import 'package:perpustakaan/pages/book_loans_overdue.dart';
import 'package:perpustakaan/pages/change-data.dart';
import 'package:perpustakaan/pages/change-password.dart';
import 'package:perpustakaan/pages/detail_peminjaman.dart';
import 'package:perpustakaan/pages/search_book.dart';
import 'package:perpustakaan/providers/api_authenticated.dart';
import 'package:perpustakaan/providers/api_category.dart';
import 'package:perpustakaan/providers/api_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/api_books.dart';
import '../widgets.dart/book_widget.dart';
import '../widgets.dart/categorywidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _role = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  ApiUser UserApi = ApiUser();
  ApiBook BookApi = ApiBook();
  ApiCategory CategoryApi = ApiCategory();
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('role') ?? '';
      print(prefs.getString('role'));
    });
  }

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
            CategoryWidget(CategoryApi: CategoryApi, BookApi: BookApi),
            Expanded(
              child: BookWidget(BookApi: BookApi),
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
              (_role == 'member')
                  ? Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.people),
                          title: Text("Profil"),
                          onTap: () async {
                            var selectedUser = await UserApi.getdatauser();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeData(user: selectedUser)),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.create),
                          title: Text("Transaksi Peminjaman"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookLoans()),
                            );
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text("Change Password"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePassword()),
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
                    )
                  : (_role == 'librarian')
                      ? Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.info),
                              title: Text("Book Loans Near Overdue"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookLoansAll()),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.info),
                              title: Text("Book Loans Overdue"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookLoansOverdue()),
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
                        )
                      : Text(' ')
            ],
          ),
        ),
      ),
    );
  }
}

