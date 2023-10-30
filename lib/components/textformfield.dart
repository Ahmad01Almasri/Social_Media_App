import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final bool obscureText;
  const CustomTextForm(
      {super.key,
      required this.hinttext,
      required this.mycontroller,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 184, 184, 184))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary))),
    );
  }
}
