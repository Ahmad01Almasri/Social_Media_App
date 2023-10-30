import 'package:flutter/material.dart';
import 'package:social_media/auth/auth.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Hi",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 100,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              height: 50,
              minWidth: 170,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              color: Colors.black,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Auth(),
                  )),
              child: const Text(
                "Next",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
