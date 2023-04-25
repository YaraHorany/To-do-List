import 'dart:convert';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/routes/route_helper.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/theme/theme.dart';
import 'package:todo_app/ui/widgets/bottom_sheet_button.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/dimensions.dart';
import 'package:todo_app/ui/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();

  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          CustomAppBar(
            title: GestureDetector(
              onTap: () {
                ThemeServices().switchTheme();
                notifyHelper.displayNotification(
                  title: "Theme changed",
                  body: Get.isDarkMode
                      ? "Activated Light Theme"
                      : "Activated Dark Theme",
                );
              },
              child: Icon(
                Get.isDarkMode
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_round,
                size: Dimensions.iconSize20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.getPreviousTasksPage());
              },
              child: Icon(
                Icons.arrow_left,
                size: 50,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: Dimensions.height10),
          _showTasks(),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin:
          EdgeInsets.only(top: Dimensions.height20, left: Dimensions.height20),
      child: DatePicker(
        DateTime.now(),
        height: Dimensions.height50 * 2,
        width: Dimensions.width20 * 4,
        initialSelectedDate: DateTime.now(),
        selectionColor: AppColors.blueColor,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: Dimensions.font10 * 2,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: Dimensions.font13,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDate) {
          _taskController.getTasks();
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(
        left: Dimensions.width20,
        right: Dimensions.width20,
        top: Dimensions.height10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.toNamed(RouteHelper.getAddEditTaskPage(''));
                _taskController.getTasks();
              }),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          int countPrev = 0;
          return ListView.builder(
              itemCount: _taskController.taskList.length,
              itemBuilder: (context, index) {
                Task task = _taskController.taskList[index];
                if (_isPreviousDate(task)) {
                  countPrev++;
                }

                // check if there's any tasks today to show notification.
                _tasksReminder(task);
                if (countPrev == _taskController.taskList.length) {
                  return _noTaskMsg();
                }

                if (task.date == DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                        child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    )),
                  );
                } else {
                  return Container();
                }
              });
        }
      }),
    );
  }

  _isPreviousDate(Task task) {
    String now = DateFormat.yMd().format(DateTime.now());
    DateTime nowDate = DateFormat("MM/dd/yyyy").parse(now);
    DateTime taskDate = DateFormat("MM/dd/yyyy").parse(task.date!);
    if (taskDate.isBefore(nowDate)) {
      return true;
    } else {
      return false;
    }
  }

  _tasksReminder(Task task) {
    if (task.date == DateFormat.yMd().format(DateTime.now()) &&
        task.isCompleted == 0) {
      DateTime date = DateFormat.jm().parse(task.startTime.toString());
      date = date.subtract(Duration(minutes: task.remind!));
      var myTime = DateFormat("HH:mm").format(date);

      notifyHelper.scheduledNotification(
        int.parse(myTime.toString().split(":")[0]),
        int.parse(myTime.toString().split(":")[1]),
        task,
      );
    }
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        color: Get.isDarkMode ? AppColors.darkGreyColor : Colors.white,
        padding: EdgeInsets.only(top: Dimensions.height5),
        height: task.isCompleted == 1
            ? Dimensions.height20 * 11
            : Dimensions.height20 * 14,
        child: Column(
          children: [
            // draw a thin horizontal line
            Container(
              height: Dimensions.height5,
              width: Dimensions.width20 * 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            // task completed button
            task.isCompleted == 1
                ? BottomSheetButton(
                    label: "Task Incomplete",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!, 0);
                      Get.back();
                    },
                    clr: AppColors.blueColor,
                    context: context)
                : BottomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!, 1);
                      notifyHelper.cancelNotification(task.id);
                      Get.back();
                    },
                    clr: AppColors.blueColor,
                    context: context),
            // Edit task button
            task.isCompleted == 1
                ? Container()
                : BottomSheetButton(
                    label: "Edit Task",
                    onTap: () {
                      Get.back();
                      Get.toNamed(RouteHelper.getAddEditTaskPage(
                          json.encode(task.toJson())));
                    },
                    clr: Colors.green,
                    context: context),
            // delete task button
            BottomSheetButton(
                label: "Delete Task",
                onTap: () {
                  _confirmDeletion(task);
                },
                clr: Colors.red[300]!,
                context: context),
            SizedBox(height: Dimensions.height10),
            // close button
            BottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.white,
              isClose: true,
              context: context,
            ),
            SizedBox(height: Dimensions.height10),
          ],
        ),
      ),
    );
  }

  _confirmDeletion(Task task) {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Please Confirm'),
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
              child: const Text(
                  'Are you sure you want to remove this task?\n You will NOT be able to undo this action!'),
            ),
            actions: [
              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () {
                  setState(() {
                    _taskController.delete(task);
                    notifyHelper.cancelNotification(task.id);
                    _showTasks();
                    Navigator.of(context).pop();
                    Get.back();
                  });
                },
                isDefaultAction: true,
                isDestructiveAction: true,
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                isDefaultAction: false,
                isDestructiveAction: false,
                child: const Text(
                  'No',
                  style: TextStyle(color: AppColors.blueColor),
                ),
              )
            ],
          );
        });
  }

  _noTaskMsg() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'images/denied-checklist-3d-clipboard-with-cross-marks.jpg',
          height: 120,
          semanticLabel: 'No Tasks',
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.height20),
          child: Text(
            "You do not have any tasks yet!\nAdd new tasks to make your day productive.",
            textAlign: TextAlign.center,
            style: subTitleStyle,
          ),
        ),
        SizedBox(
          height: Dimensions.height20 * 4,
        ),
      ],
    );
  }
}
