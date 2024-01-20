import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<Subject> subjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Subject Timetable',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subjects[index].name),
            subtitle: Text('${subjects[index].time} - ${subjects[index].day}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSubjectDialog();
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  void _showAddSubjectDialog() {
    String subjectName = '';
    String subjectTime = '';
    String subjectDay = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Subject'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  subjectName = value;
                },
                decoration: InputDecoration(labelText: 'Subject Name'),
              ),
              TextField(
                onChanged: (value) {
                  subjectTime = value;
                },
                decoration: InputDecoration(labelText: 'Time'),
              ),
              TextField(
                onChanged: (value) {
                  subjectDay = value;
                },
                decoration: InputDecoration(labelText: 'Day'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  subjects.add(Subject(
                      name: subjectName, time: subjectTime, day: subjectDay));
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Subject {
  final String name;
  final String time;
  final String day;

  Subject({required this.name, required this.time, required this.day});
}
