// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, use_build_context_synchronously, avoid_print, body_might_complete_normally_nullable, avoid_single_cascade_in_expression_statements

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_hub/widgets/custom_logo.dart';
import 'package:uni_hub/widgets/my_button.dart';
import 'package:uni_hub/widgets/text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignUpScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

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
                      height: 20,
                    ),
                    CustomLogo(
                        myImage: Image.asset(
                      'images/logo.png',
                      width: 150,
                      // height: 150,
                      // fit: BoxFit.fill,
                    )),
                    Container(height: 10),
                    Text('Register',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900)),
                    Container(height: 5),
                    Text('Register To Continue Using The App',
                        style: TextStyle(color: Colors.grey)),
                    Container(height: 5),
                    Text("Username",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    MyTextFormField(
                      validator: (val) {
                        if (val == '') {
                          return "Can't be Empty";
                        }
                      },
                      obScureText: false,
                      textType: TextInputType.name,
                      hint: "Enter Your Username ",
                      mycontroller: username,
                    ),
                    Container(height: 10),
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
                    Container(height: 10),
                    Text("Confirm Password",
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
                      hint: "Enter Confirm Password",
                      mycontroller: confirmPassword,
                    ),
                  ],
                ),
              ),
              Container(height: 10),
              MyButton(
                color: Colors.black,
                title: Text('Register'),
                onPressed: () async {
                  if (formstate.currentState!.validate()) {
                    if (password.text != confirmPassword.text) {
                      print("Entered Passwords Doesn't Match");
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: "Entered Passwords Doesn't Match",
                      ).show();
                      return;
                    }
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      Navigator.of(context).pushReplacementNamed('LogIn');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Warning',
                          desc: 'The password provided is too weak',
                        ).show();
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'The account already exists for that email',
                        ).show();
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
              ),
              Container(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Have an account ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('LogIn');
                    },
                    child: Text(
                      'Login',
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
