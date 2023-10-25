import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/constants.dart';
import 'package:timeago/timeago.dart' as tago;
import '../../../controllers/comment_controller.dart';

class Comments extends StatelessWidget {
  final String id;
  final String commentCount;
  Comments({super.key, required this.id, required this.commentCount});
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<CommentController>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.black38,
        body: Column(
          children: [
            SizedBox(height: 14),
            Text("Comments  $commentCount",style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Divider(),
            Expanded(
              child: StreamBuilder(
                stream: firestore.collection("videos").doc(id).collection("comments").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.red));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(left: 8, top: 27),
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
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 8,
                                          right: 10,
                                          // right: size.width <= 350? size.width-320:size.width <= 360?size.width-330:size.width <= 412?size.width-382:size.width-820,
                                          // right: size.width-330,
                                        ),
                                        child: Column( // here
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data!.docs[i]["username"],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width-75,
                                              child: Text(
                                                snapshot.data!.docs[i]["comment"],
                                                style: const TextStyle(
                                                  fontSize: 15,
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
                                              : Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 10),
                                    Text(
                                      tago.format(snapshot.data!.docs[i]["datePublished"].toDate()),
                                      style: const TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${snapshot.data!.docs[i]["likes"].length} likes",
                                      style: const TextStyle(fontSize: 12, color: Colors.white),
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
            const Divider(),
            ListTile(
              leading: FutureBuilder(
                future: firestore.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleAvatar(
                      backgroundColor: Colors.red,
                    );
                  }
                  return CircleAvatar(backgroundImage: NetworkImage(snapshot.data!["profilePhoto"]));
                },
              ),
              title: TextFormField(
                controller: _commentController,
                style: const TextStyle(fontSize: 16, color: Colors.white),
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
                    child: const Icon(Icons.send_sharp, color: Colors.red),
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
    );
  }
}
