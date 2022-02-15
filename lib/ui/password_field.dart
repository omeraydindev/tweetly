import 'package:flutter/material.dart';
import 'package:tweetly/utils/validators.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({this.controller, Key? key}) : super(key: key);

  final TextEditingController? controller;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.password],
      obscureText: _obscureText,
      validator: passwordValidator(),
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: "Password",
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.all(18.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            size: 24,
          ),
        ),
      ),
    );
  }
}
