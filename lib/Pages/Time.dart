// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AlarmModel {
  String key;
  late TimeOfDay time;
  late bool isEnabled;

  AlarmModel({
    String? keyAlarm,
    required this.time,
    this.isEnabled = true,
  }) : key = keyAlarm ?? DateTime.now().millisecondsSinceEpoch.toString();

  String get alarmKey => key;
}

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  late Box<AlarmModel>? alarmBox;
  late List<AlarmModel> alarms = [];
  late ValueNotifier<List<AlarmModel>> _alarmsNotifier;

  @override
  void initState() {
    super.initState();
    _alarmsNotifier = ValueNotifier<List<AlarmModel>>([]);
    _initHive();
  }

  @override
  void dispose() {
    print('Disposing widget');
    alarmBox?.close();
    super.dispose();
  }

  Future<void> _initHive() async {
  try {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AlarmModelAdapter());
    }
    await _openBox();
  } catch (e) {
    print('Error initializing Hive: $e');
  }
}

Future<void> _openBox() async {
  try {
    if (!Hive.isBoxOpen('alarms')) {
      alarmBox = await Hive.openBox<AlarmModel>('alarms');
    } else {
      alarmBox = Hive.box<AlarmModel>('alarms');
    }
    alarms = alarmBox?.values.toList() ?? [];
    _alarmsNotifier.value = alarms;
  } catch (e) {
    print('Error opening Hive box: $e');
  }
}

  Future<void> _selectTime(BuildContext context) async {
    if (alarmBox == null) {
      print('Alarm box is not initialized');
      return;
    }

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final newAlarm = AlarmModel(
        keyAlarm:
            DateTime.now().millisecondsSinceEpoch.toString(),
        time: selectedTime,
      );

      setState(() {
        alarms.add(newAlarm);
        alarmBox?.add(newAlarm);
        _alarmsNotifier.value = alarms;
      });

      _handleAlarm(newAlarm);
    }
  }

  void _handleAlarm(AlarmModel alarm) {
    final snackBar = SnackBar(
      content: Text('Alarm set for ${alarm.time.format(context)}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          'Alarm App',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _alarmsNotifier,
              builder: (context, _, __) {
                alarms = _alarmsNotifier.value;
                return ListView.builder(
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarms[index];
                    return ListTile(
                      title: Text('Time: ${alarm.time.format(context)}'),
                      subtitle: Text('Enabled: ${alarm.isEnabled}'),
                      onLongPress: () {
                        _deleteAlarm(alarm);
                      },
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _selectTime(context);
            },
            child: Text(
              'Set Alarm Time',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAlarm(AlarmModel alarm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Alarm?'),
          content: Text('Do you want to delete this alarm?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _removeAlarm(alarm);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAlarmFromBox(AlarmModel alarm) async {
  try {
    if (!Hive.isBoxOpen('alarms')) {
      await Hive.openBox<AlarmModel>('alarms');
    }
    var box = Hive.box<AlarmModel>('alarms');
    await box.delete(alarm.alarmKey);
    print('Alarm deleted from box: ${alarm.alarmKey}');
  } catch (e) {
    print('Error deleting alarm from box: $e');
  }
}
  void _removeAlarm(AlarmModel alarm) {
    print('Removing alarm locally: ${alarm.alarmKey}');
    _deleteAlarmFromBox(alarm).then((_) {
      setState(() {
        alarms.remove(alarm);
        _alarmsNotifier.value = alarms;
      });
    });
  }
}

class AlarmModelAdapter extends TypeAdapter<AlarmModel> {
  @override
  final int typeId = 1;

  @override
  AlarmModel read(BinaryReader reader) {
    return AlarmModel(
      time: TimeOfDay(
        hour: reader.readInt(),
        minute: reader.readInt(),
      ),
      isEnabled: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, AlarmModel obj) {
    writer.writeInt(obj.time.hour);
    writer.writeInt(obj.time.minute);
    writer.writeBool(obj.isEnabled);
  }
}
