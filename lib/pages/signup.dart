import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/components/button_auth.dart';
import 'package:social_media/components/textformfield.dart';

class SignUp extends StatefulWidget {
  final Function()? onTap;
  const SignUp({super.key, this.onTap});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final passwordTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final confirmTextController = TextEditingController();

  void signUp() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    if (passwordTextController.text != confirmTextController.text) {
      Navigator.pop(context);
      displayMessage("password don't match");
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email!)
          .set({
        'username': emailTextController.text.split('@')[0],
        'bio': 'Empty bio..'
      });

      if (context.mounted) Navigator.pop(context);
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                  Text("Lets create an acount for you",
                      style: TextStyle(color: Colors.grey[700])),
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
                  CustomTextForm(
                      hinttext: "Conform Password",
                      mycontroller: confirmTextController,
                      obscureText: true),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButtonAuth(
                    title: "Sign Up",
                    onPressed: signUp,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login Now",
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
