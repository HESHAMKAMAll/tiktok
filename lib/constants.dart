import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/views/screens/main_pages/add_video.dart';

List pages = [
  const Center(child: Text("One")),
  const Center(child: Text("Two")),
  AddVideoScreen(videoFile: File(""),videoPath: ""),
  const Center(child: Text("Four")),
  const Center(child: Text("Five")),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;