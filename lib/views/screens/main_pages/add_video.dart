import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/constants.dart';
import 'package:tiktok/controllers/upload_video_controller.dart';
import 'package:video_player/video_player.dart';
import '../../widgets/text_input_field.dart';

class AddVideoScreen extends StatefulWidget {
  File videoFile;
  String videoPath;

  AddVideoScreen({super.key, required this.videoFile, required this.videoPath});

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  double seekValue = 0.5;
  Timer? progressTimer;
  bool setVolume = true;
  bool? camera;
  bool hideIconPlay = false;
  late VideoPlayerController controller;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  pickVideo(ImageSource src, BuildContext context, bool) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      widget.videoFile = File(video.path);
      widget.videoPath = video.path;
      // setState(() {});
      Navigator.pop(context);
      // initState();
      if (widget.videoPath != "") {
        controller = VideoPlayerController.file(widget.videoFile);
        controller.addListener(() {
          setState(() {}); // Trigger a rebuild when the position changes
          if (controller.value.isInitialized) {
            startProgressTimer(); // Start the progress timer when video is initialized
          }
        });
        controller.initialize().then((_) {
          setState(() {});
        });
        controller.play();
        controller.setVolume(1);
        controller.setLooping(true);
      }
    } else {}
    camera = bool;
  }

  // AlertDialog
  showOptionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select video', style: TextStyle(fontSize: 20)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                    onPressed: () => pickVideo(ImageSource.gallery, context, false),
                    child: const Icon(
                      Icons.image_outlined,
                      color: Colors.white,
                      size: 45,
                    )),
                const SizedBox(width: 30),
                CupertinoButton(
                    onPressed: () => pickVideo(ImageSource.camera, context, true),
                    child: const Icon(
                      Icons.photo_camera_outlined,
                      color: Colors.white,
                      size: 45,
                    )),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cansel', style: TextStyle(color: Colors.white))),
            ],
          );
        });
  }

  @override
  void initState() {
    if (widget.videoPath != "") {
      controller = VideoPlayerController.file(widget.videoFile);
      // setState(() {});
      controller.addListener(() {
        setState(() {}); // Trigger a rebuild when the position changes
        if (controller.value.isInitialized) {
          startProgressTimer(); // Start the progress timer when video is initialized
        }
      });
      controller.initialize().then((_) {
        setState(() {});
      });
      controller.play();
      controller.setVolume(1);
      controller.setLooping(true);
    }
    super.initState();
  }

  // Method to seek to a specific position in the video
  void seekToPosition(double value) {
    if (controller != null && controller.value.isInitialized) {
      final newPosition = value * controller.value.duration.inMilliseconds;
      controller.seekTo(Duration(milliseconds: newPosition.round()));
    }
  }

  // Method to start a timer for updating seekValue
  void startProgressTimer() {
    if (progressTimer == null) {
      progressTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        if (controller != null && controller.value.isInitialized) {
          setState(() {
            seekValue = controller.value.position.inMilliseconds / controller.value.duration.inMilliseconds;
          });
        }
      });
    }
  }

  // Method to stop the progress timer
  void stopProgressTimer() {
    progressTimer?.cancel();
    progressTimer = null;
  }

  @override
  void dispose() {
    super.dispose();
    stopProgressTimer();
    if (widget.videoPath != "") {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.videoPath != ""
          ? SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    controller != null && controller.value.isInitialized
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    hideIconPlay = true;
                                    if (controller.value.isPlaying) {
                                      controller.pause();
                                    } else {
                                      controller.play();
                                    }
                                    setState(() {});
                                    Future.delayed(const Duration(seconds: 1),() {
                                      setState(() {
                                        hideIconPlay = false;
                                      });
                                    },);
                                  },
                                  child: AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller))),
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  child: CupertinoButton(
                                      onPressed: () {
                                        widget.videoPath = "";
                                        widget.videoFile = File("");
                                        controller.dispose();
                                        setState(() {});
                                      },
                                      padding: EdgeInsets.zero,
                                      child: const Icon(Icons.delete_forever_outlined, color: Colors.grey))),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CupertinoButton(
                                      onPressed: () {
                                        if (setVolume) {
                                          controller.setVolume(0);
                                          setVolume = false;
                                        } else {
                                          controller.setVolume(1);
                                          setVolume = true;
                                        }
                                        setState(() {});
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Icon(setVolume ? Icons.volume_up : Icons.volume_off, color: Colors.grey))),
                             if(hideIconPlay)
                              Center(child: Icon(controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle, color: Colors.grey,size: 50)),
                            ],
                          )
                        : const CircularProgressIndicator(),
                    Slider(
                      value: seekValue,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (value) {
                        setState(() {
                          seekValue = value;
                        });
                      },
                      onChangeEnd: (value) {
                        seekToPosition(value);
                      },
                      activeColor: Colors.red,
                    ),
                    // Progress bar
                    // LinearProgressIndicator(
                    //   value: videoProgress,
                    //   valueColor: AlwaysStoppedAnimation<Color>(buttonColor!), // Customize the color
                    //   backgroundColor: Colors.grey, // Customize the background color
                    // ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width - 20,
                            child: TextInputField(
                              controller: _songController,
                              hintText: "Song Name",
                              prefixIcon: Icons.music_note_outlined,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width - 20,
                            child: TextInputField(
                              controller: _captionController,
                              hintText: "Caption",
                              prefixIcon: Icons.closed_caption_outlined,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Consumer<UploadVideoController>(
                            builder: (context, value, child) {
                              if (context.read<UploadVideoController>().isLoading) {
                                return ElevatedButton(
                                    onPressed: () {}, child: const Text("Loading...", style: TextStyle(fontSize: 17, color: Colors.white)));
                              }
                              return CupertinoButton(
                                  onPressed: () async {
                                    if (!camera!) {
                                      // For gallery no compressing
                                      controller.setLooping(false);
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return Dialog(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: 60,
                                                    width: 30,
                                                    child: Center(
                                                      child: CircularProgressIndicator(color: buttonColor),
                                                    ),
                                                  ),
                                                  const Text("Posting your video"),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                            );
                                          });
                                      await value.uploadVideo(
                                        _songController.text,
                                        _captionController.text,
                                        widget.videoPath,
                                        context,
                                      );

                                      widget.videoPath = "";
                                      widget.videoFile = File("");
                                      controller.dispose();
                                    } else {
                                      // For Camera to compressing
                                      controller.setLooping(false);
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return Dialog(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: 60,
                                                    width: 30,
                                                    child: Center(
                                                      child: CircularProgressIndicator(color: buttonColor),
                                                    ),
                                                  ),
                                                  const Text("Posting your video"),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                            );
                                          });
                                      await value.uploadVideoForCamera(
                                        _songController.text,
                                        _captionController.text,
                                        widget.videoPath,
                                        context,
                                      );

                                      widget.videoPath = "";
                                      widget.videoFile = File("");
                                      controller.dispose();
                                    }
                                  },
                                  color: buttonColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: const Text("Share!", style: TextStyle(fontSize: 25, color: Colors.white)));
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 62),
                  ],
                ),
              ),
            )
          : Center(
              child: CupertinoButton(
                onPressed: () => showOptionDialog(context),
                color: buttonColor,
                child: const Text("Add Video", style: TextStyle(color: Colors.white)),
              ),
            ),
    );
  }
}
