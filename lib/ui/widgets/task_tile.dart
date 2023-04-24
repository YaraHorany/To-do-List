import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/dimensions.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  const TaskTile(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      child: Container(
        padding: EdgeInsets.all(Dimensions.height15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          color: _getBGClr(task?.color ?? 0),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task?.title ?? "",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey[200],
                      size: Dimensions.iconSize18,
                    ),
                    SizedBox(width: Dimensions.width10 / 2),
                    Text(
                      "${task!.startTime}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: Dimensions.font13,
                            color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
                task!.note == ""
                    ? Container()
                    : SizedBox(height: Dimensions.height15),
                task!.note == ""
                    ? Container()
                    : Text(
                        task?.note ?? "",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: Dimensions.font10 * 1.5,
                              color: Colors.grey[100]),
                        ),
                      ),
              ],
            ),
          ),
          // draw a thin vertical line
          Container(
            margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
            height: Dimensions.height20 * 3,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task!.isCompleted == 1 ? "COMPLETED" : "TODO",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: Dimensions.font10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return AppColors.blueColor;
      case 1:
        return AppColors.redColor;
      case 2:
        return AppColors.yellowColor;
      case 3:
        return AppColors.greenColor;
      case 4:
        return AppColors.pinkColor;
      default:
        return AppColors.blueColor;
    }
  }
}
