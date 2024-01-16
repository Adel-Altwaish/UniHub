// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    required this.hint,
    required this.mycontroller,
    required this.textType,
    required this.obScureText,
    required this.validator,
  });
  final String hint;
  final TextEditingController mycontroller;
  final TextInputType textType;
  final bool obScureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      textInputAction: TextInputAction.next,
      keyboardType: textType,
      obscureText: obScureText,
      controller: mycontroller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey[400]),
        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 233, 228, 228),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 233, 228, 228),
          ),
        ),
      ),
    );
  }
}
