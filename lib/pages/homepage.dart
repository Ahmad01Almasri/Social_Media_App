import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/components/drawer.dart';
import 'package:social_media/components/post.dart';
import 'package:social_media/components/textformfield.dart';
import 'package:social_media/helper/helper_methods.dart';
import 'package:social_media/pages/profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  void postmessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Post").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
    setState(() {
      textController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: MyDrawer(
          onLogouttap: FirebaseAuth.instance.signOut,
          onPerofiletap: goToProfilePage),
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Hi         ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Post")
                  .orderBy("TimeStamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data!.docs[index];
                      return Post(
                        message: post['Message'],
                        user: post['UserEmail'],
                        time: formatDate(post['TimeStamp']),
                        postId: post.id,
                        likes: List<String>.from(
                            post['Likes'] != null ? post['Likes'] : []),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error" + snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                      child: CustomTextForm(
                          hinttext: "write something here...",
                          mycontroller: textController,
                          obscureText: false)),
                  IconButton(
                      onPressed: postmessage,
                      icon: const Icon(Icons.arrow_circle_up))
                ],
              ),
            ),
            Text("Logged in as :${currentUser.email!}",
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
