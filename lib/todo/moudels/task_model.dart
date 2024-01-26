// ignore_for_file: depend_on_referenced_packages

import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  bool isDone;

  TaskModel({
    required this.name,
    required this.isDone,
  });

  void doneChange() {
    isDone = !isDone;
    save();
  }
}
