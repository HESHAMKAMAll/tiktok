import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/controllers/video_contoller.dart';
import 'package:tiktok/views/screens/main_pages/comments.dart';
import '../../widgets/circle_animation.dart';
import '../../widgets/video_player_item.dart';

class Videos extends StatefulWidget {
  final uid;
  int selected;

  Videos({super.key, this.uid, required this.selected});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(
                    profilePhoto,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildMusicalAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.white,
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(image: NetworkImage(profilePhoto), fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(initialPage: widget.selected, viewportFraction: 1);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("videos").where("uid", isEqualTo: widget.uid["uid"]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          return PageView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, i) {
              final data = snapshot.data!.docs[i];
              return Stack(
                children: [
                  VideoPlayerItem(videoUrl: data["videoUrl"]),
                  Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(data["username"],
                                        style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text(data["caption"], style: const TextStyle(fontSize: 15, color: Colors.white)),
                                    Row(
                                      children: [
                                        const Icon(Icons.music_note, color: Colors.white, size: 15),
                                        Text(data["songName"],
                                            style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(top: size.height / 2.4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildProfile(data["profilePhoto"]),
                                  Column(
                                    children: [
                                      CupertinoButton(
                                        onPressed: () async {
                                          await VideoController().likePost(
                                            data.id,
                                            FirebaseAuth.instance.currentUser!.uid,
                                            data["likes"],
                                          );
                                          await VideoController().likeUser(
                                            data["uid"],
                                          );
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          size: 35,
                                          color: data["likes"].contains(FirebaseAuth.instance.currentUser!.uid) ? Colors.red : Colors.white,
                                        ),
                                      ),
                                      Text(
                                        data["likes"].length.toString(),
                                        style: const TextStyle(fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CupertinoButton(
                                        onPressed: () => showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return Container(
                                              height: MediaQuery.of(context).size.height - 150, // Adjust the value as needed
                                              child: Comments(
                                                  id: data.id, commentCount: data["commentCount"].toString()), // Your content goes here
                                            );
                                          },
                                        ),
                                        child: const Icon(Icons.comment, size: 35, color: Colors.white),
                                      ),
                                      Text(
                                        data["commentCount"].toString(),
                                        style: const TextStyle(fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CupertinoButton(
                                        onPressed: () {},
                                        child: const Icon(Icons.reply, size: 35, color: Colors.white),
                                      ),
                                      Text(
                                        data["shareCount"].toString(),
                                        style: const TextStyle(fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  CircleAnimation(child: buildMusicalAlbum(data["profilePhoto"])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
