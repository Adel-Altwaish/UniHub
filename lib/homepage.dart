import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("الأقســـــــام")),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("LogIn", (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(child: Center(child: Text('Welcome'))),
    );
  }
}
