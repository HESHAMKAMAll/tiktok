import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/views/screens/main_pages/add_video.dart';
import 'package:tiktok/views/screens/main_pages/home.dart';
import 'package:tiktok/views/screens/main_pages/profile.dart';
import 'package:tiktok/views/screens/main_pages/search.dart';

List pages = [
  Home(),
  Search(),
  AddVideoScreen(videoFile: File(""), videoPath: ""),
  Center(child: ElevatedButton(onPressed: ()async{await FirebaseAuth.instance.signOut();}, child: Text("Sign Out"))),
  Profile(data: 1),
  // StreamBuilder(
  //   stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
  //   builder: (context, snapshot) {
  //     if(snapshot.connectionState==ConnectionState.waiting){
  //       return Center(child: CircularProgressIndicator(color: buttonColor,));
  //     }
  //     return Profile(data: snapshot.data);
  //   },
  // ),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
// var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;
