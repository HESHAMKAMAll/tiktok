import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants.dart';
import 'package:tiktok/controllers/video_contoller.dart';
import 'package:tiktok/views/screens/main_pages/comments.dart';
import '../../widgets/circle_animation.dart';
import '../../widgets/video_player_item.dart';

int _currentPageIndex = 0;

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController(initialPage: _currentPageIndex, viewportFraction: 1);

  final VideoController videoController = Get.put(VideoController());

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          itemCount: videoController.videoList.length,
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            return Stack(
              children: [
                // VideoPlayerItem(videoUrl: data.videoUrl),
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
                                  Text(data.username, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text(data.caption, style: const TextStyle(fontSize: 15, color: Colors.white)),
                                  Row(
                                    children: [
                                      const Icon(Icons.music_note, color: Colors.white, size: 15),
                                      Text(data.songName, style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: size.height / 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildProfile(data.profilePhoto),
                                Column(
                                  children: [
                                    CupertinoButton(
                                      onPressed: () async {
                                        await VideoController().likePost(
                                          data.id,
                                          firebaseAuth.currentUser!.uid,
                                          data.likes,
                                        );
                                      },
                                      child: Icon(
                                        Icons.favorite,
                                        size: 35,
                                        color: data.likes.contains(firebaseAuth.currentUser!.uid) ? Colors.red : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      data.likes.length.toString(),
                                      style: const TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    CupertinoButton(
                                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Comments(id: data.id))),
                                      child: const Icon(Icons.comment, size: 35, color: Colors.white),
                                    ),
                                    Text(
                                      data.commentCount.toString(),
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
                                      data.shareCount.toString(),
                                      style: const TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                                CircleAnimation(child: buildMusicalAlbum(data.profilePhoto)),
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
      }),
    );
  }
}
