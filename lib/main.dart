import 'package:flutter/material.dart';
import 'package:tweetly/api/session.dart';
import 'package:tweetly/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static late SessionManager sessionManager;

  MyApp({Key? key}) : super(key: key) {
    sessionManager = SessionManager.of(this);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
