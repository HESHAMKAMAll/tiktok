import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(firestore.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(Video.fromSnap(element));
      }
      return retVal;
    }));
  }


  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection("videos").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore.collection("videos").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeUser(String uid) async {
    var data = await firestore.collection("users").doc(uid).get();
    try {
      if (data["likes"].contains(FirebaseAuth.instance.currentUser!.uid)) {
        await firestore.collection("users").doc(uid).update({
          "likes": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
        });
      } else {
        await firestore.collection("users").doc(uid).update({
          "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }



//
// likeVideo(String id) async {
//   DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
//   var uid = authController.user.uid;
//   if ((doc.data()! as dynamic)['likes'].contains(uid)) {
//     await firestore.collection('videos').doc(id).update({
//       'likes': FieldValue.arrayRemove([uid]),
//     });
//   } else {
//     await firestore.collection('videos').doc(id).update({
//       'likes': FieldValue.arrayUnion([uid]),
//     });
//   }
// }
}
