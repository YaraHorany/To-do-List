import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/theme/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/custom_app_bar.dart';
import 'package:todo_app/ui/widgets/input_field.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/utils/dimensions.dart';

class AddEditTaskPage extends StatefulWidget {
  final String? task;
  const AddEditTaskPage({Key? key, this.task}) : super(key: key);

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  List<int> remindList = [
    0,
    5,
    10,
    15,
    20,
  ];
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
  ];

  late Task task;
  late int _selectedColor;
  late DateTime _selectedDate;
  late String _startTime;
  late String _selectedRepeat;
  late int _selectedRemind;
  late bool isUpdating;
  late bool isUpdatingColor;
  late bool isUpdatingDate;
  late bool isUpdatingStartTime;
  late bool isUpdatingRemind;

  @override
  void initState() {
    super.initState();
    // Adding a new task.
    if (widget.task == '') {
      _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
      _selectedDate = DateTime.now();
      _selectedRepeat = "None";
      _selectedRemind = 0;
      _selectedColor = 0;
      isUpdatingColor = false;
      isUpdating = false;
      isUpdatingDate = false;
      isUpdatingStartTime = false;
      isUpdatingRemind = false;
    } else {
      // Updating an existing task.
      isUpdating = true;
      isUpdatingColor = true;
      isUpdatingDate = true;
      isUpdatingStartTime = true;
      isUpdatingRemind = true;

      task = Task.fromJson(jsonDecode(widget.task!));
      _selectedColor = task.color!;
      _startTime = task.startTime!;
      _selectedRepeat = task.repeat!;
      _selectedRemind = task.remind!;
      _titleController.text = task.title!;
      _noteController.text = task.note!;
      _selectedDate = DateFormat("MM/dd/yyyy").parse(task.date!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: Dimensions.iconSize20,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Text(isUpdating ? "Edit Task" : "Add Task", style: headingStyle),
              MyInputField(
                title: "Title",
                hint: "Enter title here.",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter title note.",
                controller: _noteController,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              MyInputField(
                title: "Start Time",
                hint: isUpdatingStartTime ? task.startTime! : _startTime,
                widget: IconButton(
                  onPressed: () {
                    _getTimeFromUser();
                  },
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
              MyInputField(
                title: "Remind",
                hint: isUpdatingRemind
                    ? "${task.remind} minutes early"
                    : "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon:
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: Dimensions.iconSize32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                      isUpdatingRemind = false;
                    });
                  },
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: isUpdating ? task.repeat! : _selectedRepeat,
                widget: DropdownButton(
                  icon:
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: Dimensions.iconSize32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      enabled: isUpdating ? false : true,
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                      if (_selectedRepeat != 'None') {
                        showCupertinoDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return CupertinoAlertDialog(
                                // title: const Text(''),
                                content: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height10),
                                  child: _selectedRepeat == 'Daily'
                                      ? const Text(
                                          'This Task will be repeated for\n the coming 7 days.')
                                      : _selectedRepeat == 'Weekly'
                                          ? const Text(
                                              'This Task will be repeated weekly\n for the coming 7 weeks')
                                          : const Text(''),
                                ),
                                actions: [
                                  // "Ok" button
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    isDefaultAction: true,
                                    isDestructiveAction: true,
                                    child: const Text(
                                      'Ok',
                                      style:
                                          TextStyle(color: AppColors.blueColor),
                                    ),
                                  )
                                ],
                              );
                            });
                      }
                    });
                  },
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(
                      label: isUpdating ? "Edit Task" : "Create Task",
                      onTap: () {
                        _validateDate();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getDateFromUser() async {
    String nowYear = DateFormat('yyyy').format(DateTime.now());
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: isUpdating
          ? DateFormat("MM/dd/yyyy").parse(task.date!)
          : DateTime.now(),
      firstDate: DateTime(int.parse(nowYear)),
      lastDate: DateTime(2100),
    );
    if (pickerDate != null) {
      int differenceInDays = pickerDate.difference(DateTime.now()).inDays;
      if (differenceInDays < 0) {
        _showSnackBar(
            "Invalid date",
            "The chosen date must be no earlier than today.",
            AppColors.redColor);
      } else {
        setState(() {
          _selectedDate = pickerDate;
          isUpdatingDate = false;
        });
      }
    }
  }

  _getTimeFromUser() async {
    TimeOfDay? pickedTime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          // _startTime --> 10:30 AM
          hour: isUpdatingStartTime
              ? int.parse(task.startTime!.split(":")[0])
              : int.parse(_startTime.split(":")[0]),
          minute: isUpdatingStartTime
              ? int.parse(task.startTime!.split(":")[1].split(" ")[0])
              : int.parse(_startTime.split(":")[1].split(" ")[0]),
        ),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // Using 12-Hour format
                alwaysUse24HourFormat: false,
              ),
              child: childWidget!);
        });

    String formattedTime = pickedTime!.format(context);

    // convert 24-hour format to 12-hour format if needed.
    if (formattedTime.contains('AM') == false &&
        formattedTime.contains('PM') == false) {
      formattedTime =
          DateFormat.jm().format(DateFormat("hh:mm").parse(formattedTime));
    }

    setState(() {
      _startTime = formattedTime;
      isUpdatingStartTime = false;
    });
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        SizedBox(height: Dimensions.height10 * 4 / 5),
        Wrap(
          children: List<Widget>.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  isUpdatingColor = false;
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(right: Dimensions.width10 * 4 / 5),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? AppColors.blueColor
                      : index == 1
                          ? AppColors.redColor
                          : index == 2
                              ? AppColors.yellowColor
                              : index == 3
                                  ? AppColors.greenColor
                                  : AppColors.pinkColor,
                  child:
                      (isUpdatingColor ? task.color! : _selectedColor) == index
                          ? const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 16,
                            )
                          : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty) {
      _addOrUpdateTask();
      Get.back();
    } else if (_titleController.text.isEmpty) {
      _showSnackBar("Required", "Title cannot be empty.", AppColors.redColor);
    }
  }

  _addOrUpdateTask() async {
    // Updating the task
    if (isUpdating) {
      await _updateTask();
      _showSnackBar(
          "Task Edited", "Task successfully edited.", AppColors.greenColor);
    } else {
      // Adding a new task to database
      await _addTaskToDb();
      _showSnackBar(
          "Task Saved", "Task successfully saved.", AppColors.greenColor);
    }
  }

  _updateTask() async {
    _taskController.updateTask(task.copy(
      title: _titleController.text,
      note: _noteController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0,
    ));
  }

  _addTaskToDb() async {
    if (_selectedRepeat == 'Daily') {
      for (int i = 0; i < 7; i++) {
        await _newTask(
            DateFormat.yMd().format(_selectedDate.add(Duration(days: i))));
      }
    } else if (_selectedRepeat == 'None') {
      await _newTask(DateFormat.yMd().format(_selectedDate));
    } else if (_selectedRepeat == 'Weekly') {
      for (int i = 0; i < 7; i++) {
        await _newTask(
            DateFormat.yMd().format(_selectedDate.add(Duration(days: i * 7))));
      }
    }
  }

  _newTask(String? date) async {
    return await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        date: date,
        startTime: _startTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
  }

  _showSnackBar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: color,
      icon: Icon(
        Icons.warning_amber_rounded,
        color: color,
      ),
    );
  }
}
