import 'package:agua_machine_test/models/task.dart';
import 'package:agua_machine_test/utils/generate_id.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskController extends GetxController with GetTickerProviderStateMixin {
  @override
  void onInit() {
    viewMore.value = List.generate(categories.length, (index) => false);
    animationControllers = List.generate(
      categories.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..forward(),
    );

    updateScreen();
    super.onInit();
  }

  late List<AnimationController> animationControllers;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  var category = '';

  var viewMore = <bool>[].obs;
  var categories = {'Work': [], 'Personal': [], 'Others': []}.obs;

  var progress = 0.0.obs;

  final Box<Task> taskBox = TaskDB().box;

  var formKey = GlobalKey<FormState>();

  addTask(String title, String description, String category) {
    Task task = Task(
      id: generateId(taskBox),
      title: title,
      description: description,
      category: category,
      createdAt: DateTime.now(),
    );
    taskBox.put(task.id, task);
    categories[task.category]!.add(task);
    categories.refresh();
    Get.back();
    sortList();
    updateProgress();
  }

// fetching all tasks and adding to respective categories
  updateScreen() {
    for (var element in taskBox.values) {
      categories[element.category]!.add(element);
      categories.refresh();
      sortList();
    }
    updateProgress();
  }

  deleteTask(Task task, int index) {
    var removedItem = categories[task.category]![index];
    categories[task.category]!.remove(task);
    // delete data from hive after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      // after 4 seconds, if the task is not in the list, delete it
      if (!categories[task.category]!.contains(task)) {
        taskBox.delete(task.id);
      }
    });
    sortList();
    // undo option in snackbar
    Get.snackbar(
      'Item Deleted',
      'Item has been deleted',
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: () {
          categories[task.category]!.insert(index, removedItem);
          Get.closeCurrentSnackbar();
          categories.refresh();
        },
        child: const Text(
          'UNDO',
          style: TextStyle(color: Colors.yellow),
        ),
      ),
      duration: const Duration(seconds: 4),
    );
  }

  updateTask(int id) {
    Task task = taskBox.get(id)!;
    task.status = 'Completed';
    taskBox.put(task.id, task);
    categories.refresh();
    sortList();
    updateProgress();
  }

  // sorting tasks
  // completed tasks on bottom and pending tasks on top
  sortList() {
    for (var element in categories.entries) {
      element.value.sort(
        (a, b) => b.status.compareTo(a.status),
      );
    }
  }

  search(String value) {
    if (value.isEmpty) {
      updateScreen();
      viewMore.value = List.generate(categories.length, (index) => false);
    } else {
      categories.value = {
        'Work': taskBox.values
            .where(
              (task) =>
                  task.category == 'Work' &&
                  task.title.toLowerCase().contains(value.toLowerCase()),
            )
            .toList(),
        'Personal': taskBox.values
            .where(
              (task) =>
                  task.category == 'Personal' &&
                  task.title.toLowerCase().contains(value.toLowerCase()),
            )
            .toList(),
        'Others': taskBox.values
            .where(
              (task) =>
                  task.category == 'Others' &&
                  task.title.toLowerCase().contains(value.toLowerCase()),
            )
            .toList(),
      };
      for (var element in categories.entries) {
        if (element.value.isNotEmpty) {
          // set view more to true
          viewMore[categories.keys.toList().indexOf(element.key)] = true;
        }
      }
      categories.refresh();
    }
  }

  updateProgress() {
    progress.value = 0.0;
    int totalEntry = taskBox.values.length;
    int completedEntry =
        taskBox.values.where((task) => task.status == 'Completed').length;
    progress.value = completedEntry / totalEntry;
  }
}
