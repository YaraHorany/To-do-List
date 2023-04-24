import 'package:flutter/material.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/dimensions.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Dimensions.width20 * 6,
        height: Dimensions.height50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          color: AppColors.blueColor,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
