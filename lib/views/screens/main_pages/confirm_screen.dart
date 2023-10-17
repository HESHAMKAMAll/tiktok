// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:tiktok/views/widgets/text_input_field.dart';
// import 'package:video_player/video_player.dart';
//
// import '../main_screen.dart';
//
// class ConfirmScreen extends StatefulWidget {
//   final File videoFile;
//   final String videoPath;
//
//   const ConfirmScreen({super.key, required this.videoFile, required this.videoPath});
//
//   @override
//   State<ConfirmScreen> createState() => _ConfirmScreenState();
// }
//
// class _ConfirmScreenState extends State<ConfirmScreen> {
//   late VideoPlayerController controller;
//   final TextEditingController songController = TextEditingController();
//   final TextEditingController captionController = TextEditingController();
//
//   @override
//   void initState() {
//     setState(() {
//       controller = VideoPlayerController.file(widget.videoFile);
//     });
//     controller.initialize().then((_) {
//       setState(() {});
//     });
//     controller.play();
//     controller.setVolume(1);
//     controller.setLooping(true);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 30),
//             controller.value.isInitialized?
//             AspectRatio(aspectRatio: controller.value.aspectRatio,child: VideoPlayer(controller)):CircularProgressIndicator(),
//             SizedBox(height: 30),
//             SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 10),
//                     width: MediaQuery.of(context).size.width - 20,
//                     child: TextInputField(
//                       controller: songController,
//                       labelText: "Song Name",
//                       prefixIcon: Icons.music_note_outlined,
//                       keyboardType: TextInputType.text,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 10),
//                     width: MediaQuery.of(context).size.width - 20,
//                     child: TextInputField(
//                       controller: captionController,
//                       labelText: "Caption",
//                       prefixIcon: Icons.closed_caption_outlined,
//                       keyboardType: TextInputType.text,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));}, child: Text("Share!",style: TextStyle(fontSize: 20,color: Colors.white))),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
