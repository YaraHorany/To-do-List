import 'package:get/get.dart';
import 'package:todo_app/ui/add_task_bar.dart';
import 'package:todo_app/ui/home_page.dart';
import 'package:todo_app/ui/previous_tasks.dart';

class RouteHelper {
  static const String initial = "/";
  static const String addEditTaskPage = "/add-task-page";
  static const String previousTasksPage = "/previous-tasks-page";

  static String getInitial() => initial;
  static String getAddEditTaskPage(String? task) =>
      '$addEditTaskPage?task=$task';
  static String getPreviousTasksPage() => previousTasksPage;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const HomePage()),
    GetPage(
      name: addEditTaskPage,
      page: () {
        var task = Get.parameters['task'];
        return AddEditTaskPage(task: task);
      },
    ),
    GetPage(name: previousTasksPage, page: () => const PreviousTasksPage()),
  ];
}
