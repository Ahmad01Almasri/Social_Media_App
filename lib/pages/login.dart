import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/components/button_auth.dart';
import 'package:social_media/components/textformfield.dart';

class Login extends StatefulWidget {
  final Function()? ontap;
  const Login({super.key, this.ontap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final passwordTextController = TextEditingController();

  final emailTextController = TextEditingController();
  void signin() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 110,
                  ),
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Welcome", style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextForm(
                      hinttext: "Email",
                      mycontroller: emailTextController,
                      obscureText: false),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                      hinttext: "Password",
                      mycontroller: passwordTextController,
                      obscureText: true),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButtonAuth(
                    title: "Sign In",
                    onPressed: signin,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.ontap,
                        child: const Text(
                          "Register Now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
