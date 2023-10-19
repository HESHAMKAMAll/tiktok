import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/controllers/video+contoller.dart';
import '../../widgets/circle_animation.dart';
import '../../widgets/video_player_item.dart';

class Home extends StatelessWidget {
  Home({super.key});
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
              padding: EdgeInsets.all(1),
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
            padding: EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.white,
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(image: NetworkImage(profilePhoto),fit: BoxFit.cover),
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
      body: Obx(
        () {
          return PageView.builder(
            itemCount: videoController.videoList.length,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final data = videoController.videoList[index];
              return Stack(
                children: [
                  VideoPlayerItem(videoUrl: data.videoUrl),
                  Column(
                    children: [
                      SizedBox(height: 100),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(data.username, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text(data.caption, style: TextStyle(fontSize: 15, color: Colors.white)),
                                    Row(
                                      children: [
                                        Icon(Icons.music_note, color: Colors.white, size: 15),
                                        Text(data.songName, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(top: size.height / 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildProfile(data.profilePhoto),
                                  Column(
                                    children: [
                                      CupertinoButton(
                                        onPressed: () {},
                                        child: Icon(Icons.favorite, size: 40, color: Colors.red),
                                      ),
                                      SizedBox(height: 7),
                                      Text(
                                        data.likes.length.toString(),
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CupertinoButton(
                                        onPressed: () {},
                                        child: Icon(Icons.comment, size: 40, color: Colors.white),
                                      ),
                                      SizedBox(height: 7),
                                      Text(
                                        data.commentCount.toString(),
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CupertinoButton(
                                        onPressed: () {},
                                        child: Icon(Icons.reply, size: 40, color: Colors.white),
                                      ),
                                      SizedBox(height: 7),
                                      Text(
                                        data.shareCount.toString(),
                                        style: TextStyle(fontSize: 20, color: Colors.white),
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
                      SizedBox(height: 60),
                    ],
                  ),
                ],
              );
            },
          );
        }
      ),
    );
  }
}
