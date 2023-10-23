import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/constants.dart';
import 'package:timeago/timeago.dart' as tago;
import '../../../controllers/comment_controller.dart';

class Comments extends StatelessWidget {
  final String id;

  Comments({super.key, required this.id});

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // CommentController().updatePostId(id);
    final size = MediaQuery.of(context).size;
    return Consumer<CommentController>(
      builder: (context, value, child) => Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: firestore.collection("videos").doc(id).collection("comments").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: Colors.red));
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(right: 8, left: 8, top: 27),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage: NetworkImage(snapshot.data!.docs[i]["profilePhoto"]),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Card(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(top: 8, bottom: 8, left: 8, right: MediaQuery.of(context).size.width / 5.3),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[i]["username"],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 220,
                                                  child: Text(
                                                    snapshot.data!.docs[i]["comment"],
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: CupertinoButton(
                                            onPressed: () {
                                              value.likeComment(snapshot.data!.docs[i]["id"], id);
                                            },
                                            padding: EdgeInsets.zero,
                                            child: Icon(
                                              Icons.favorite,
                                              size: 25,
                                              color: (snapshot.data!.docs[i]["likes"]).contains(FirebaseAuth.instance.currentUser!.uid)
                                                  ? Colors.red
                                                  : Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(width: 10),
                                        Text(
                                          tago.format(snapshot.data!.docs[i]["datePublished"].toDate()),
                                          style: TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "${snapshot.data!.docs[i]["likes"].length} likes",
                                          style: TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  leading: FutureBuilder(
                    future: firestore.collection("users").doc(firebaseAuth.currentUser!.uid).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          backgroundColor: Colors.red,
                        );
                      }
                      return CircleAvatar(backgroundImage: NetworkImage(snapshot.data!["profilePhoto"]));
                    },
                  ),
                  title: TextFormField(
                    controller: _commentController,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    decoration: InputDecoration(
                      suffixIcon: CupertinoButton(
                        onPressed: () async {
                          if (_commentController.text.isNotEmpty) {
                            await value.postComment(_commentController.text, id);
                            _commentController.clear();
                            FocusManager.instance.primaryFocus!.unfocus();
                          }
                        },
                        padding: EdgeInsets.zero,
                        child: Icon(Icons.send_sharp, color: Colors.red),
                      ),
                      hintText: "Comment",
                      filled: true,
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(50)),
                      focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
