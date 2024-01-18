// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_unnecessary_containers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).pushNamed('AddCategory');
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Center(child: Text("الأقســـــــام")),
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("LogIn", (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 150),
        children: [
          Card(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Image.asset(
                      'images/1.jpg',
                      height: 150,
                    ),
                    Text('المنبه'),
                  ],
                ),
              ),
            ),
          ),
          Card(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Image.asset(
                      'images/1.jpg',
                      height: 150,
                    ),
                    Text('المهام'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
