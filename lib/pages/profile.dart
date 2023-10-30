import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Edit $field",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.grey[900],
              content: TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Enter new $field",
                    hintStyle: const TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  newValue = value;
                },
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(newValue);
                    },
                    child: const Text("Save")),
              ],
            ));
    if (newValue.trim().length > 0) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Center(
              child: Text(
            "Profile Page         ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.person,
                  size: 70,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "My Details",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                MyTextBox(
                  text: userData['username'],
                  sectionName: "username",
                  onPressed: () => editField("username"),
                ),
                MyTextBox(
                  text: userData['bio'],
                  sectionName: "bio",
                  onPressed: () => editField("bio"),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "My Posts",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ]);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Erorr${snapshot.error}"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
