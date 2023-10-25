import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class ProfileController extends ChangeNotifier {

  followersUser(String userId, String uid, List follow)async{
    var data = await firestore.collection("users").doc(userId).get();
    try {
      if (data["followers"].contains(uid)) {
        await firestore.collection("users").doc(userId).update({
          "followers": FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore.collection("users").doc(userId).update({
          "followers": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }


  followingUser(String userId, List follow)async{
    var data = await firestore.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    try {
      if (data["following"].contains(userId)) {
        await firestore.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
          "following": FieldValue.arrayRemove([userId]),
        });
      } else {
        await firestore.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
          "following": FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

}