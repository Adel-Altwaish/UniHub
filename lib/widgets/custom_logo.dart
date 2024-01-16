// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({
    super.key, required this.myImage,
  });
final Image myImage;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 100,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(70)),
        child: myImage,
      ),
    );
  }
}