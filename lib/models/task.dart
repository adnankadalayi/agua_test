import 'package:hive_flutter/hive_flutter.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String title;

  @HiveField(1)
  String? description;

  @HiveField(2)
  String category;

  @HiveField(3)
  String status;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  int id;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    this.status = 'Pending',
    required this.createdAt,
  });
}

class TaskDB {
  late Box<Task> box;
  static final TaskDB _singleton = TaskDB._internal();
  init() async {
    box = await Hive.openBox<Task>('tasks');
  }

  factory TaskDB() => _singleton;
  TaskDB._internal();
}
