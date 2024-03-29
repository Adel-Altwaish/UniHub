import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_hub/todo/moudels/task_data.dart';

import 'task_tile.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemCount: taskData.tasks!.length,
          itemBuilder: (context, index) {
            return TaskTile(
              isChecked: taskData.tasks![index].isDone,
              taskTitle: taskData.tasks![index].name,
              checkBoxChange: (newValue) {
                taskData.updateTask(taskData.tasks![index]);
              },
              listTileDelete: () {
                taskData.deleteTask(taskData.tasks![index]);
              },
            );
          },
        );
      },
    );
  }
}
