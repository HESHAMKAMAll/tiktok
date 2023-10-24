import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final data;
  const Profile({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: data!=null? Center(child: Text("Profile ${data["name"]}")):const Center(child: Text("Profile")),
    );
  }
}
