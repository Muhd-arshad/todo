import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/controller/task_controller.dart';
import 'package:todo/view/task_adding_screen.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<TaskController>(context, listen: false).getTasks();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Task',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskAddingScreen(),
                  ));
            },
            child: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Consumer<TaskController>(
        builder: (context, taskController, _) {
          if (taskController.loadingScreen) {
            return const Center(child: CircularProgressIndicator());
          } else if (taskController.task.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: const Center(
                child: Text(
                  'No task added',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  taskController.task[index].title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      taskController.deleteTask(
                                          taskController.task[index].docid);
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              taskController.task[index].description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date: ${taskController.task[index].date}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Time: ${taskController.task[index].time}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                    itemCount: taskController.task.length,
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
