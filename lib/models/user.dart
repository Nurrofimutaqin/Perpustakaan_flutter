  import 'package:flutter/foundation.dart';

  class User {
    final String username, first_name, last_name, email;

    User({required this.username,required this.first_name,required this.last_name,required this.email});
    factory User.fromJson(Map<String, dynamic> json) {
      return User(
          username: json['username'],
          first_name: json['first_name'],
          last_name: json['last_name'],
          email: json['email'],
          );
    }

  }
