import 'package:agua_machine_test/models/task.dart';
import 'package:agua_machine_test/task/controllers/task_controller.dart';
import 'package:agua_machine_test/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key});

  final controller = Get.put(TaskController());
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Management',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          const Icon(Icons.light_mode),
          Obx(
            () => Switch(
              activeColor: Colors.green,
              value: themeController.themeMode.value == ThemeMode.dark,
              onChanged: (value) {
                themeController
                    .toggleTheme(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          const Icon(Icons.dark_mode),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff6101EE),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          bottonSheet(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  controller.search(value);
                }),
            const SizedBox(height: 10),
            Obx(
              () => CircularProgressIndicator(
                value: controller.progress.value,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
                  'Progress: ${(controller.progress.value * 100).toStringAsFixed(1)}%',
                )),
            const SizedBox(height: 10),
            Obx(
              () => Expanded(
                child: ListView(
                  children: List.generate(
                    controller.categories.length,
                    (index) {
                      var category =
                          controller.categories.entries.toList()[index];
                      return Column(
                        children: [
                          Card(
                            child: ListTile(
                              title: Text(category.key),
                              trailing: IconButton(
                                icon: AnimatedRotation(
                                  turns: controller.viewMore[index] ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child:
                                      const Icon(Icons.arrow_drop_down_sharp),
                                ),
                                onPressed: () {
                                  controller.viewMore[index] =
                                      !controller.viewMore[index];
                                },
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: controller.viewMore[index]
                                ? Column(
                                    key: ValueKey(index),
                                    children: List.generate(
                                      category.value.length,
                                      (taskIndex) {
                                        Task task = category.value[taskIndex];
                                        return Dismissible(
                                          key: UniqueKey(),
                                          background: Container(
                                            color: Colors.green,
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                          secondaryBackground: Container(
                                            color: Colors.red,
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                          onDismissed: (direction) {
                                            if (direction ==
                                                DismissDirection.startToEnd) {
                                              controller.updateTask(task.id);
                                            } else {
                                              controller.deleteTask(
                                                  task, taskIndex);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(1, 0),
                                                end: Offset.zero,
                                              ).animate(
                                                CurvedAnimation(
                                                  parent: controller
                                                          .animationControllers[
                                                      index],
                                                  curve: Curves.easeInOut,
                                                ),
                                              ),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                curve: Curves.easeInOut,
                                                width: double.infinity,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black26),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(context)
                                                      .cardTheme
                                                      .color,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset:
                                                          const Offset(0, 3),
                                                    )
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        task.title,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        task.description ??
                                                            'No description',
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: task.status ==
                                                                  'Pending'
                                                              ? Colors.purple
                                                              : Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Text(
                                                          task.status,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bottonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Add Task',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.descriptionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select one',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select one';
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'Work',
                          child: Text('Work'),
                        ),
                        DropdownMenuItem(
                          value: 'Personal',
                          child: Text('Personal'),
                        ),
                        DropdownMenuItem(
                          value: 'Others',
                          child: Text('Others'),
                        ),
                      ],
                      onChanged: (value) {
                        controller.category = value.toString();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6101EE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            if (controller.descriptionController.text.isEmpty) {
                              controller.descriptionController.text =
                                  'No description';
                            }
                            controller.addTask(
                              controller.titleController.text,
                              controller.descriptionController.text,
                              controller.category,
                            );
                            controller.titleController.clear();
                            controller.descriptionController.clear();
                            controller.category = '';
                            controller.formKey.currentState!.save();
                            Get.back();
                          }
                        },
                        child: const Text(
                          'Add Task',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
