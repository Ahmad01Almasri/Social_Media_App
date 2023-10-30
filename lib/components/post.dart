import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/components/comment.dart';
import 'package:social_media/components/comment_button.dart';
import 'package:social_media/components/delet_button.dart';
import 'package:social_media/components/like_button.dart';
import 'package:social_media/helper/helper_methods.dart';

class Post extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const Post({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _commentTextController = TextEditingController();
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Post').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Post")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "Commentby": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add Comment"),
              content: TextField(
                autofocus: true,
                controller: _commentTextController,
                decoration:
                    const InputDecoration(hintText: "Write a comment.."),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _commentTextController.clear();
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        addComment(_commentTextController.text);
                        _commentTextController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text("Post"),
                    ),
                  ],
                )
              ],
            ));
  }

  void deletPost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delet Post"),
              content: const Text("Are you sure you want delet this post"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                          final commentDocs = await FirebaseFirestore.instance
                              .collection("User Post")
                              .doc(widget.postId)
                              .collection("Comments")
                              .get();
                          for (var doc in commentDocs.docs) {
                            await FirebaseFirestore.instance
                                .collection("User Post")
                                .doc(widget.postId)
                                .collection("Comments")
                                .doc(doc.id)
                                .delete();
                          }
                          FirebaseFirestore.instance
                              .collection("User Post")
                              .doc(widget.postId)
                              .delete();

                          Navigator.pop(context);
                        },
                        child: const Text("Delet")),
                  ],
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${widget.user.split("@")[0]} ... ",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            Text(
                              widget.time,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        DeletButton(
                          onTap: deletPost,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.message)
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        LikeButton(isLiked: isLiked, onTap: toggleLike),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.likes.length.toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        CommentButton(onTap: showCommentDialog),
                        const SizedBox(
                          height: 12,
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Post")
                    .doc(widget.postId)
                    .collection("Comments")
                    .orderBy("CommentTime", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      final commentData = doc.data() as Map<String, dynamic>;
                      return Comment(
                          text: commentData["CommentText"],
                          user: commentData["Commentby"],
                          time: formatDate(commentData["CommentTime"]));
                    }).toList(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
