// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_hub/todo/screens/add_tasks_screen.dart';

import '../moudels/task_data.dart';
import '../widgets/tasks_list.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<TaskData>(context, listen: false).openHiveBox(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey,
              actions: [
                Icon(
                  Icons.playlist_add_check,
                  size: 40,
                  color: Colors.black,
                ),
                SizedBox(width: 20),
              ],
              title: Text(
                'ToDayDo',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: AddTasksScreen((newTaskTitle) {}),
                    ),
                  ),
                );
              },
              backgroundColor: Colors.grey[400],
              child: Icon(Icons.add),
            ),
            backgroundColor: Colors.grey,
            body: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 80,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<TaskData>(
                    builder: (context, taskData, child) {
                      final tasksCount = taskData.tasks?.length ?? 0;
                      print('Tasks count: $tasksCount');
                      return Text(
                        '${tasksCount} Tasks',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.white.withOpacity(0.8),
                                BlendMode.srcATop,
                              ),
                              child: Image.asset(
                                'images/logo.png',
                              ),
                            ),
                          ),
                          TasksList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Text('Press the button to start.');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
