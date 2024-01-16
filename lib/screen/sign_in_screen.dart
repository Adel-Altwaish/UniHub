// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, avoid_print, use_build_context_synchronously, body_might_complete_normally_nullable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uni_hub/widgets/custom_logo.dart';
import 'package:uni_hub/widgets/my_button.dart';
import 'package:uni_hub/widgets/text_form_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.of(context).pushNamedAndRemoveUntil('HomePage',(route)=> false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('UniHub'),
          ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Form(
                key: formstate,
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
                      // height: 150,
                      // fit: BoxFit.fill,
                    )),
                    Container(height: 20),
                    Text('Login',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900)),
                    Container(height: 10),
                    Text('Login To Continue Using The App',
                        style: TextStyle(color: Colors.grey)),
                    Container(height: 20),
                    Text("Email",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    MyTextFormField(
                      validator: (val) {
                        if (val == '') {
                          return "Can't be Empty";
                        }
                      },
                      obScureText: false,
                      textType: TextInputType.emailAddress,
                      hint: "Enter Your Email ",
                      mycontroller: email,
                    ),
                    Container(height: 10),
                    Text("Password",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    MyTextFormField(
                      validator: (val) {
                        if (val == '') {
                          return "Can't be Empty";
                        }
                      },
                      obScureText: true,
                      textType: TextInputType.visiblePassword,
                      hint: "Enter Your Password",
                      mycontroller: password,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: Text("Forgot Password?",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14))),
                    ),
                  ],
                ),
              ),
              MyButton(
                color: Colors.black,
                title: Text('Login'),
                onPressed: () async {
                  if (formstate.currentState!.validate()) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: password.text);
                      if (credential.user!.emailVerified) {
                        Navigator.of(context).pushReplacementNamed('HomePage');
                      } else {
                        // FirebaseAuth.instance.currentUser!
                        //     .sendEmailVerification();
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.rightSlide,
                          dialogType: DialogType.info,
                          title: 'Need Verify',
                          desc: "Please go to your email and verify it",
                        ).show();
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.rightSlide,
                          dialogType: DialogType.error,
                          title: 'Error',
                          desc: 'No user found for that email',
                        ).show();
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.rightSlide,
                          dialogType: DialogType.error,
                          title: 'Error',
                          desc: 'Wrong password provided for that user',
                        ).show();
                      }
                    }
                  } else {
                    print('Not Valid');
                  }
                },
              ),
              Container(height: 20),
              // Text('Or Login With', textAlign: TextAlign.center),
              // Container(height: 20),
              MyButton(
                color: Color.fromARGB(255, 188, 49, 39),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Login With Google   '),
                    Image.asset(
                      'images/2.png',
                      width: 30,
                    ),
                  ],
                ),
                onPressed: () {
                  signInWithGoogle();
                },
              ),
              Container(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('SignUp');
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
