import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_bloc/models/task.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() {
    return _instance;
  }

  HiveService._internal();

  static const String _tasksBoxName = 'tasks';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>(_tasksBoxName);
  }

  Box<Task> get tasksBox => Hive.box<Task>(_tasksBoxName);
}