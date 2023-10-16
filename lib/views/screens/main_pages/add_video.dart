import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/constants.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoButton(
          onPressed: ()=>showOptionDialog(context),
          color: buttonColor,
          child: Text("Add Video",style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
