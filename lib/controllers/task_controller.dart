import 'package:get/get.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/db/db_helper.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    // it returns the id of the last inserted row, 0 if it fails to insert.
    return await DBHelper.insert(task);
  }

  void updateTask(Task task) async {
    await DBHelper.update(task);
    getTasks();
  }

  // get the data from the table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) async {
    var val = await DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id, int isCompleted) async {
    await DBHelper.updateIsCompleted(id, isCompleted);
    getTasks();
  }
}
