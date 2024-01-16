import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  // ignore: use_super_parameters
  const MyButton({
    Key? key,
    required this.color,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final Widget title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: color,
      textColor: Colors.white,
      onPressed: onPressed,
      child: title,
    );
  }
}
