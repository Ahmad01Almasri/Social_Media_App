import 'package:flutter/material.dart';
import 'package:social_media/pages/login.dart';
import 'package:social_media/pages/signup.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool showLoginPage = true;
  void toogLepages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(ontap: toogLepages);
    } else {
      return SignUp(
        onTap: toogLepages,
      );
    }
  }
}
