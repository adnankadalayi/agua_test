import 'package:agua_machine_test/models/task.dart';
import 'package:agua_machine_test/task/views/task_screen.dart';
import 'package:agua_machine_test/theme/app_theme.dart';
import 'package:agua_machine_test/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());
  await TaskDB().init();
  Get.put(ThemeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode.value,
      home: TaskScreen(),
    );
  }
}
