// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _Scetion1State();
}

class _Scetion1State extends State<Book> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books'),),
    );
  }
}
