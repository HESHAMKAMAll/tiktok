import 'package:flutter/material.dart';

class MaterialCustom extends StatelessWidget {
  var child;
  final Color MaterialColor;
  final double borderRadius;
  MaterialCustom({super.key,required this.child,this.MaterialColor = Colors.white,this.borderRadius = 50.0});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: 2,
      shadowColor: Colors.grey[100],
      // color: MaterialColor,
      child: child,
    );
  }
}
