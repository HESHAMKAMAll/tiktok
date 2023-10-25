import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String profilePhoto;
  String email;
  String uid;
  var followers;
  var following;
  var likes;

  User({
    required this.name,
    required this.profilePhoto,
    required this.email,
    required this.uid,
    required this.followers,
    required this.following,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "email": email,
        "uid": uid,
        "followers": [],
        "following": [],
        "likes": [],
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      name: snapshot["name"],
      profilePhoto: snapshot["profilePhoto"],
      email: snapshot["email"],
      uid: snapshot["uid"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      likes: snapshot["likes"],
    );
  }
}
