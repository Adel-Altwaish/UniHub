// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uni_hub/Pages/alarm.dart';
import 'package:uni_hub/pages/homepage.dart';
import 'package:uni_hub/screen/sign_in_screen.dart';
import 'package:uni_hub/screen/sign_up_screen.dart';
import 'package:uni_hub/todo/moudels/constant.dart';
import 'package:uni_hub/todo/moudels/task_data.dart';
import 'package:uni_hub/todo/moudels/task_model.dart';
import 'package:uni_hub/todo/screens/tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>(kTasksBox);

  await initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskData()..init()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initializeFirebase() async {
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA34vYH8_FS14Pffqis4MtN0kazNfx5lHA",
            appId: "1:223401995351:android:14aeb15fc9ec2ca2160712",
            messagingSenderId: "223401995351",
            projectId: "unihub-eecad"));
  } else {
    await Firebase.initializeApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage()
          : SignInScreen(),
      routes: {
        Routes.signUp: (context) => SignUpScreen(),
        Routes.logIn: (context) => SignInScreen(),
        Routes.homePage: (context) => HomePage(),
        Routes.taskScreen: (context) => TasksScreen(),
        Routes.alarm: (context) => Alarm(),
      },
    );
  }
}

class Routes {
  static const signUp = 'SignUp';
  static const logIn = 'LogIn';
  static const homePage = 'HomePage';
  static const taskScreen = 'TaskScreen';
  static const alarm = 'Alarm';
}
