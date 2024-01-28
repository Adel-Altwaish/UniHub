// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Coming Soon...')),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.8),
            BlendMode.srcATop,
          ),
          child: Image.asset('images/logo.png'),
        ),
      ]),
    );
  }
}
