import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/theme/theme.dart';
import 'package:todo_app/utils/dimensions.dart';

class BottomSheetButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  final Color clr;
  final bool isClose;
  final BuildContext context;
  const BottomSheetButton(
      {Key? key,
      required this.label,
      required this.onTap,
      required this.clr,
      this.isClose = false,
      required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Dimensions.height5),
        height: Dimensions.height50,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isClose ? Colors.transparent : clr,
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
