// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uni_hub/widgets/customtextformfieldadd.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: MyTextFormFieldAdd(
                hint: 'ُEnter Name',
                mycontroller: name,
                textType: TextInputType.name,
                obScureText: false,
                validator: (val) {
                  if (val == "") {
                    return "Can't be Empty";
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
