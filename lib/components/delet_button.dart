import 'package:flutter/material.dart';

class DeletButton extends StatelessWidget {
  final void Function()? onTap;
  const DeletButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.cancel,
        color: Colors.grey[700],
      ),
    );
  }
}
