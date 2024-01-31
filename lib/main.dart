import 'package:flutter/material.dart';
import 'package:perpustakaan/pages/book_loans.dart';
import 'package:perpustakaan/pages/home.dart';
import 'package:perpustakaan/pages/loginpages.dart';
import 'package:perpustakaan/providers/api_user.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=> ApiUser())
      
    ],
     child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Flutter App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/peminjaman': (context) => BookLoans(),
        // ... rute-rute lainnya
      },
    )
    );
  }
}
