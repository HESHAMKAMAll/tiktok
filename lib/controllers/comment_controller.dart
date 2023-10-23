import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants.dart';
import '../models/comment_model.dart';

class CommentController extends ChangeNotifier {
  final List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  // String _postId = "";
  //
  // updatePostId(String id) {
  //   _postId = id;
  //   getComment();
  // }

  getComment() async {}

  postComment(String commentText,postId) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
        var allDocs = await firestore.collection('videos').doc(postId).collection('comments').get();
        int len = allDocs.docs.length;
        Comment comment = Comment(
          username: (userDoc.data()! as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)['profilePhoto'],
          uid: FirebaseAuth.instance.currentUser!.uid,
          id: 'Comment $len',
        );
        await firestore.collection('videos').doc(postId).collection('comments').doc('Comment $len').set(comment.toJson());
        DocumentSnapshot doc = await firestore.collection('videos').doc(postId).get();
        await firestore.collection('videos').doc(postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error While Commenting',
        e.toString(),
        duration: Duration(seconds: 50)
      );
    }
  }

  likeComment(String id,postId) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await firestore
        .collection('videos')
        .doc(postId)
        .collection('comments')
        .doc(id)
        .get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore
          .collection('videos')
          .doc(postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore
          .collection('videos')
          .doc(postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
