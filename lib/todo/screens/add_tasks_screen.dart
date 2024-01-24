// ignore_for_file: sort_child_properties_last, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_hub/todo/moudels/task_data.dart';

class AddTasksScreen extends StatelessWidget {
  final Function addTaskCallBack;
  const AddTasksScreen(this.addTaskCallBack, {super.key});

  @override
  Widget build(BuildContext context) {
    String? newTaskTitle;
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add Task',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            cursorColor: Colors.black,
            autofocus: true,
            textAlign: TextAlign.center,
            onChanged: (newText) {
              newTaskTitle = newText;
            },
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              print('Adding task: $newTaskTitle');
              Provider.of<TaskData>(context, listen: false)
                  .addTasks(newTaskTitle!);
              Navigator.pop(context);
            },
            child: const Text('Add'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
