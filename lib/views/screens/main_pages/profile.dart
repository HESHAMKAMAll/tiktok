import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tiktok/views/screens/side_pages/videos.dart';
import '../../../constants.dart';
import '../../../controllers/profile_controller.dart';

class Profile extends StatelessWidget {
  final data;
  const Profile({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data != 1
          ? FirebaseFirestore.instance.collection("users").doc(data['uid']).get()
          : FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: buttonColor));
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
            leading: Icon(Icons.person_add_alt_1_outlined),
            title: Text(snapshot.data!['name'], style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              Icon(Icons.more_horiz),
            ],
          ),
          body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot.data!['profilePhoto'],
                                    height: 100,
                                    width: 100,
                                    // placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.error,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            StreamBuilder(
                              stream: data != 1
                                  ? FirebaseFirestore.instance.collection("users").doc(data['uid']).snapshots()
                                  : FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                             builder: (context, snapshot) {
                               if (snapshot.connectionState == ConnectionState.waiting) {
                                 return Center(child: CircularProgressIndicator(color: buttonColor));
                               }
                               return Column(
                                 children: [
                                   const SizedBox(height: 15),
                                   Row(
                                     children: [
                                       Spacer(flex: 3),
                                       Column(
                                         children: [
                                           Text(
                                             snapshot.data!["following"].length.toString(),
                                             style: const TextStyle(
                                               fontSize: 20,
                                               fontWeight: FontWeight.bold,
                                             ),
                                           ),
                                           const SizedBox(height: 5),
                                           const Text(
                                             'Following',
                                             style: TextStyle(
                                               fontSize: 14,
                                             ),
                                           ),
                                         ],
                                       ),
                                       Spacer(),
                                       Column(
                                         children: [
                                           Text(
                                             snapshot.data!["followers"].length.toString(),
                                             style: const TextStyle(
                                               fontSize: 20,
                                               fontWeight: FontWeight.bold,
                                             ),
                                           ),
                                           const SizedBox(height: 5),
                                           const Text(
                                             'Followers',
                                             style: TextStyle(
                                               fontSize: 14,
                                             ),
                                           ),
                                         ],
                                       ),
                                       Spacer(),
                                       Column(
                                         children: [
                                           Text(
                                             snapshot.data!["likes"].length.toString(),
                                             style: const TextStyle(
                                               fontSize: 20,
                                               fontWeight: FontWeight.bold,
                                             ),
                                           ),
                                           const SizedBox(height: 5),
                                           const Text(
                                             '   Likes   ',
                                             style: TextStyle(
                                               fontSize: 14,
                                             ),
                                           ),
                                         ],
                                       ),
                                       Spacer(flex: 3),
                                     ],
                                   ),
                                   const SizedBox(height: 25),
                                   SizedBox(
                                     width: MediaQuery.of(context).size.width - 30,
                                     child: CupertinoButton(
                                       onPressed: () async {
                                         if (snapshot.data!["uid"] == FirebaseAuth.instance.currentUser!.uid) {
                                           await FirebaseAuth.instance.signOut();
                                         } else {
                                           await ProfileController().followersUser(
                                             snapshot.data!["uid"],
                                             FirebaseAuth.instance.currentUser!.uid,
                                             snapshot.data!["followers"],
                                           );
                                           await ProfileController().followingUser(
                                             snapshot.data!["uid"],
                                             snapshot.data!["following"],
                                           );
                                         }
                                       },
                                       color: buttonColor,
                                       child: Text(
                                         snapshot.data!["followers"].contains(FirebaseAuth.instance.currentUser!.uid)
                                             ? "Unfollow"
                                             : snapshot.data!["uid"] == FirebaseAuth.instance.currentUser!.uid
                                             ? "Sign Out"
                                             : "Follow",
                                         style: const TextStyle(
                                           fontSize: 20,
                                           color: Colors.white,
                                           fontWeight: FontWeight.bold,
                                         ),
                                       ),
                                     ),
                                   ),
                                   const SizedBox(height: 25),
                                 ],
                               );
                             },
                            ),
                            FutureBuilder(
                              future: FirebaseFirestore.instance.collection('videos').where('uid', isEqualTo: snapshot.data!["uid"]).get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox();
                                }
                                return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: (snapshot.data! as dynamic).docs.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                                    return GestureDetector(
                                      // onTap: (){
                                      //   print(index);
                                      //   print("========================");
                                      // },
                                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => Videos(uid: snap,selected: index))),
                                      child: SizedBox(
                                        child: Image(
                                          image: NetworkImage(snap['thumbnail']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
    );
  }
}
