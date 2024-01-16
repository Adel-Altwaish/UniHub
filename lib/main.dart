// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uni_hub/homepage.dart';
import 'package:uni_hub/screen/sign_in_screen.dart';
import 'package:uni_hub/screen/sign_up_screen.dart';

// import '../screen/welcome_screen.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyCJiv7T9SbnXrDttgSsal85diL76wxXE-Q",
              appId: "1:223482781353:android:e320fb4bf875d485e453b8",
              messagingSenderId: "223482781353",
              projectId: "unihub-d8428"))
      : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage()
          : SignInScreen(),
      routes: {
        'SignUp': (context) => SignUpScreen(),
        'LogIn': (context) => SignInScreen(),
        'HomePage': (context) => HomePage(),
        
      },
    );
  }
}






      //   WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
      //   RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
      //   SectionsScreen.screenRoute: (context) => SectionsScreen(),
