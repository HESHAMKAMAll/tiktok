import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/views/screens/main_pages/add_video.dart';
import 'package:tiktok/views/screens/main_pages/confirm_screen.dart';

List pages = [
  Center(child: Text("One")),
  Center(child: Text("Two")),
  AddVideoScreen(videoFile: File(""),videoPath: ""),
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