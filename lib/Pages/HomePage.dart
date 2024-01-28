// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unnecessary_string_interpolations, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uni_hub/Pages/alarm.dart';
import 'package:uni_hub/Pages/book.dart';
import 'package:uni_hub/Pages/coming_soon.dart';
import 'package:uni_hub/Pages/schedule.dart';
import 'package:uni_hub/todo/screens/tasks_screen.dart';
import 'package:uni_hub/widgets/custom_logo.dart';

Future<String> _loadUsername() async {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
  return doc['username'] ?? 'Not logged in';
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Tooltip(
            message: 'Logout',
            child: IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("LogIn", (route) => false);
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ),
        ],
        title: const Center(
          child: Text(
            "S E C T I O N S",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                ),
                CustomLogo(
                  myImage: Image.asset(
                    'images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                Container(height: 20),
                Center(
                  child: Text(
                    "UniHub",
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                const Divider(),
                Container(height: 20),
                Text(
                  'Email Address:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Container(height: 10),
                Text(
                  '${FirebaseAuth.instance.currentUser!.email}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Container(height: 20),
                Text(
                  'Username:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Container(height: 10),
                FutureBuilder<String>(
                  future: _loadUsername(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Text(
                        '${snapshot.data ?? FirebaseAuth.instance.currentUser?.displayName ?? 'Not logged in'}',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
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
          Center(
            child: GridView.count(
              padding: EdgeInsets.only(top: 40),
              crossAxisCount: 2,
              children: [
                _buildCard(context, 'Tasks', TasksScreen(), Icons.task),
                _buildCard(
                    context, 'Add schedule', Schedule(), Icons.schedule),
                _buildCard(context, 'Clock', Clock(), Icons.alarm),
                _buildCard(
                    context, 'Books', BooksPage(), Icons.menu_book_sharp),
                _buildCard(
                    context, 'Coming Soon...', ComingSoon(), Icons.android),
                _buildCard(
                    context, 'Coming Soon...', ComingSoon(), Icons.android),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, Widget page, IconData icon) {
    return Card(
      color: Colors.white24,
      elevation: 20.0,
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(
              message: title,
              child: Icon(icon, size: 60.0),
            ),
            Container(height: 10),
            Text(title, style: Theme.of(context).textTheme.headline6),
          ],
        ),
      ),
    );
  }
}
