import 'dart:convert';

import 'package:tweetly/api/session.dart';

class LoginRegisterInfo {
  String username;
  String? email;
  String? fullName;
  String password;

  LoginRegisterInfo({
    required this.username,
    this.email,
    this.fullName,
    required this.password,
  });

  String toJson() => jsonEncode({
        "username": username,
        "email": email,
        "fullName": fullName,
        "password": password,
      });
}

class LoginRegisterResult {
  final bool success;
  final String? errorMessage;
  final Session? session;

  LoginRegisterResult({required this.success, this.errorMessage, this.session});
}
