import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tweetly/api/api.dart';
import 'package:tweetly/models/login_register.dart';
import 'package:tweetly/screens/home.dart';
import 'package:tweetly/ui/basics.dart';
import 'package:tweetly/utils/route.dart';
import 'package:tweetly/ui/password_field.dart';

import 'package:tweetly/main.dart';
import 'package:tweetly/constants.dart';
import 'package:tweetly/utils/animation.dart';
import 'package:tweetly/utils/validators.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: [
          buildIcon(context),
          const LoginForm(),
        ],
      ),
    );
  }

  Widget buildIcon(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.40,
      child: Image.asset(
        "images/icon.png",
        width: 50,
        height: 50,
        color: Colors.white,
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _signupFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignUp = false;

  GlobalKey<FormState> formKey() => _isSignUp ? _signupFormKey : _loginFormKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // load the saved username from local storage
    getSavedUsername().then((value) {
      _usernameController.text = value;
    });
  }

  static const usernameKey = "username";

  Future<String> getSavedUsername() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(usernameKey) ?? "";
  }

  Future<void> saveUsername() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(usernameKey, _usernameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => ScaleTransition(
        child: child,
        scale: animation,
      ),
      layoutBuilder: AnimationUtils.nonCenteredLayoutBuilder,
      child: buildForm(),
    );
  }

  Widget buildForm() {
    return Form(
      key: formKey(),
      child: Column(
        children: [
          buildGreetingText(),
          const SizedBox(height: 10),

          // full name field (for signing up)
          if (_isSignUp) const SizedBox(height: 10),
          if (_isSignUp) buildFullNameField(),

          // username field
          const SizedBox(height: 10),
          buildUsernameField(),

          // email field (for signing up)
          if (_isSignUp) const SizedBox(height: 10),
          if (_isSignUp) buildEmailField(),

          // password field
          const SizedBox(height: 10),
          buildPasswordField(),

          // submit button
          const SizedBox(height: 20),
          buildSubmitButton(),

          // text to switch forms
          const SizedBox(height: 30),
          GestureDetector(
            child: buildFormSwitcherText(),
            onTap: () {
              setState(() => _isSignUp = !_isSignUp);
            },
          ),
        ],
      ),
    );
  }

  Widget buildGreetingText() {
    return Text(
      _isSignUp ? "Join tweetly today." : "Log in to your account.",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontFamily: 'Quicksand',
      ),
    );
  }

  Widget buildFullNameField() {
    return TextFormField(
      controller: _fullNameController,
      decoration: buildRoundedInputDecoration("Full name"),
      validator: fullNameValidator(),
    );
  }

  Widget buildUsernameField() {
    return TextFormField(
      autofillHints: const [AutofillHints.username],
      controller: _usernameController,
      decoration: buildRoundedInputDecoration("Username"),
      validator: usernameValidator(),
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      autofillHints: const [AutofillHints.email],
      controller: _emailController,
      decoration: buildRoundedInputDecoration("Email"),
      validator: emailValidator(),
    );
  }

  Widget buildPasswordField() {
    return PasswordField(
      controller: _passwordController,
    );
  }

  Widget buildFormSwitcherText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white, fontSize: 15),
            children: [
              TextSpan(
                  text: _isSignUp
                      ? "Have an account already?"
                      : "Don't have an account?"),
              TextSpan(
                text: _isSignUp ? " Log in" : " Sign up",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration buildRoundedInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.all(18.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      errorMaxLines: 2,
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: submit,
      child: Text(
        _isSignUp ? "Sign up" : "Log in",
        style: const TextStyle(
          color: primaryColor,
          fontSize: 18,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        shape: const StadiumBorder(),
        primary: Colors.white,
      ),
    );
  }

  void submit() {
    // validate input
    if (!formKey().currentState!.validate()) return;

    // show progress modal
    context.showBasicProgressModal();

    // create form info
    final info = LoginRegisterInfo(
      username: _usernameController.text,
      email: _isSignUp ? _emailController.text : null,
      fullName: _isSignUp ? _fullNameController.text : null,
      password: _passwordController.text,
    );

    // use API to register/login
    final apiFuture = _isSignUp ? API.registerUser(info) : API.loginUser(info);
    apiFuture.then((value) {
      // dismiss progress modal
      Navigator.of(context).pop();

      // set current session
      MyApp.sessionManager.setSession(value);

      // save username for later
      saveUsername().then((value) => null);

      // go to next page
      Navigator.of(context).pushReplacement(createBTTSlideRoute(
        page: const HomePage(),
      ));
    }).catchError((error) {
      // dismiss progress modal
      Navigator.of(context).pop();

      // show error dialog
      context.showBasicDialog(
        title: "Error",
        message: error.toString(),
        okButtonText: "OK",
      );
    });
  }
}
