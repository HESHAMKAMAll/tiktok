import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/views/screens/main_pages/add_video.dart';
import 'package:tiktok/views/screens/main_pages/confirm_screen.dart';

List<Widget> pages = [
  Center(child: Text("One")),
  Center(child: Text("Two")),
  AddVideoScreen(),
  Center(child: Text("Four")),
  Center(child: Text("Five")),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

pickVideo(ImageSource src,BuildContext context)async{
  final video = await ImagePicker().pickVideo(source: src);
  if(video!=null){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmScreen(videoFile: File(video.path),videoPath: video.path,)));
  }else{}
}

// AlertDialog
showOptionDialog(BuildContext context){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Text('Select video',style: TextStyle(fontSize: 20)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoButton(onPressed: ()=>pickVideo(ImageSource.gallery,context), child: Icon(Icons.image_outlined,color: Colors.white,size: 45,)),
          SizedBox(width: 30),
          CupertinoButton(onPressed: ()=>pickVideo(ImageSource.camera,context), child: Icon(Icons.photo_camera_outlined,color: Colors.white,size: 45,)),
        ],
      ),
      actions: [
        ElevatedButton(onPressed: (){Navigator.pop(context);},child: Text('Cansel',style: TextStyle(color: Colors.white))),
      ],);
  });
}