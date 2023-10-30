import 'package:flutter/material.dart';

class MyListTitel extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? ontap;
  const MyListTitel(
      {super.key, required this.icon, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: ontap,
    );
  }
}
