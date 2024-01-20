// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_unnecessary_containers

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.grey,
      //   onPressed: () {
      //     Navigator.of(context).pushNamed('AddCategory');
      //   },
      //   child: Icon(Icons.add),
      // ),
      // appBar: AppBar(
      //   title: Center(child: Text("الأقســـــــام")),
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         GoogleSignIn googleSignIn = GoogleSignIn();
      //         googleSignIn.disconnect();
      //         await FirebaseAuth.instance.signOut();
      //         Navigator.of(context)
      //             .pushNamedAndRemoveUntil("LogIn", (route) => false);
      //       },
      //       icon: Icon(Icons.exit_to_app),
      //     ),
      //   ],
      // ),
      // body: GridView(
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 2, mainAxisExtent: 150),
      //   children: [
      //     Card(
      //       child: Container(
      //           padding: const EdgeInsets.all(10),
      //           child: Column(
      //             children: [
      //               Image.asset(
      //                 'images/4.png',
      //                 height: 100,
      //               ),
      //               Text('المنبه'),
      //             ],
      //           ),
      //         ),
      //       ),
//           Card(
//             child: Container(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       'images/3.png',
//                       height: 100,
//                     ),
//                     Text('المهام'),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
