import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.all(25),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sectionName),
                IconButton(
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.settings,
                    )),
              ],
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
