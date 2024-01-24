// task_data.dart

// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uni_hub/todo/moudels/task_model.dart';

class TaskData extends ChangeNotifier {
  late Box<TaskModel>? taskBox;

  Future<void> openHiveBox() async {
    taskBox = await Hive.openBox<TaskModel>('tasks_box');
    notifyListeners();
  }

  Future<void> init() async {
    await openHiveBox();
  }

  void addTasks(String newTaskTitle) {
    print('Adding task: $newTaskTitle');
    if (taskBox != null) {
      taskBox!.add(TaskModel(name: newTaskTitle, isDone: false));
      notifyListeners();
    } else {
      print('taskBox is null');
    }
  }

  void updateTask(TaskModel task) {
    if (taskBox != null) {
      task.doneChange();
      task.save();
      notifyListeners();
    } else {
      print('taskBox is null');
    }
  }

  void deleteTask(TaskModel task) {
    if (taskBox != null) {
      task.delete();
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('taskBox is null');
      }
    }
  }

  List<TaskModel>? get tasks {
    if (taskBox != null) {
      return taskBox?.values.toList();
    } else {
      print('taskBox is null');
      return [];
    }
  }
}
