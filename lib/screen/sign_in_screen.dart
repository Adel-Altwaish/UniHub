// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, avoid_print, use_build_context_synchronously, body_might_complete_normally_nullable, dead_code

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

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.of(context).pushNamedAndRemoveUntil('HomePage', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Welcome To UniHub',
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              Form(
                key: formState,
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
                      ),
                    ),
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
                        onPressed: () async {
                          if (email.text == '') {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.error,
                              title: 'Error',
                              desc: 'Please Enter your email',
                            ).show();
                          }
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email.text);
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.success,
                              title: 'Success',
                              desc: 'Reset Password email Has been sent!',
                            ).show();
                          } catch (e) {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.rightSlide,
                              dialogType: DialogType.error,
                              title: 'Error',
                              desc: 'There is no account for this email!',
                            ).show();
                          }
                        },
                        child: Text(
                          "Forgot Password?",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MyButton(
                color: Colors.black,
                title: Text('Login'),
                onPressed: () async {
                  if (formState.currentState!.validate()) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: password.text);
                      if (credential.user!.emailVerified) {
                        Navigator.of(context).pushReplacementNamed('HomePage');
                      } else {
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
              MyButton(
                color: Color.fromARGB(255, 188, 49, 39),
                onPressed: () {
                  signInWithGoogle();
                },
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
