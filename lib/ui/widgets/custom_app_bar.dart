import 'package:flutter/material.dart';
import 'package:todo_app/utils/dimensions.dart';

class CustomAppBar extends StatelessWidget {
  final Widget leading;
  final Widget? title;

  const CustomAppBar({Key? key, this.title, required this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: Dimensions.height5 * 5, bottom: Dimensions.height10),
      padding: title == null
          ? const EdgeInsets.all(0)
          : EdgeInsets.only(
              left: Dimensions.width10, right: Dimensions.width10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leading,
          title == null ? Container() : title!,
          const CircleAvatar(backgroundImage: AssetImage("images/user.jpg")),
        ],
      ),
    );
  }
}
