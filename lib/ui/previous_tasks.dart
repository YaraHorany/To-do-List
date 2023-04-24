import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/ui/widgets/bottom_sheet_button.dart';
import 'package:todo_app/ui/widgets/custom_app_bar.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/theme/theme.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/dimensions.dart';
import 'home_page.dart';

class PreviousTasksPage extends StatefulWidget {
  const PreviousTasksPage({Key? key}) : super(key: key);

  @override
  State<PreviousTasksPage> createState() => _PreviousTasksPageState();
}

class _PreviousTasksPageState extends State<PreviousTasksPage> {
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Previous Tasks',
              style: headingStyle,
            ),
            leading: GestureDetector(
              onTap: () {
                Get.to(() => const HomePage());
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          _showPreviousTasks(),
        ],
      ),
    );
  }

  _showPreviousTasks() {
    if (_taskController.taskList.isEmpty) {
      return Container();
    } else {
      return Flexible(
        child: ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (BuildContext context, int index) {
            Task task = _taskController.taskList[index];
            var dateTime = DateFormat('MM/dd/yy').parse(task.date!);
            return _isPreviousDate(task)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: Dimensions.width5 * 5,
                            bottom: Dimensions.height5),
                        child: Text(
                          DateFormat.yMMMMd().format(dateTime),
                          style: subHeadingStyle,
                        ),
                      ),
                      AnimationConfiguration.staggeredList(
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
                      ),
                    ],
                  )
                : Container();
          },
        ),
      );
    }
  }

  _isPreviousDate(Task task) {
    String now = DateFormat.yMd().format(DateTime.now());
    DateTime nowDate = DateFormat("MM/dd/yyyy").parse(now);
    DateTime taskDate = DateFormat("MM/dd/yyyy").parse(task.date!);
    if (taskDate.isBefore(nowDate)) {
      return true;
    }
    return false;
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        color: Get.isDarkMode ? AppColors.darkGreyColor : Colors.white,
        padding: EdgeInsets.only(top: Dimensions.height5),
        height: Dimensions.height20 * 8,
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
}
