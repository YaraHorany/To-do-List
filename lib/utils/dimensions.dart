import 'package:get/get.dart';

class Dimensions {
  // Nexus 6 - width = 411.42857142857144
  // Nexus 6 - height = 683.4285714285714

  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  // dynamic height padding and margin
  static double height5 = screenHeight / 136.68;
  static double height10 = screenHeight / 68.34;
  static double height15 = screenHeight / 45.56;
  static double height20 = screenHeight / 34.17;
  static double height50 = screenHeight / 13.66;

  // dynamic width padding and margin
  static double width5 = screenWidth / 82.28;
  static double width10 = screenWidth / 41.14;
  static double width15 = screenWidth / 27.42;
  static double width20 = screenWidth / 20.57;

  // icon size
  static double iconSize18 = screenHeight / 37.96;
  static double iconSize20 = screenHeight / 34.17;
  static double iconSize32 = screenHeight / 19.43;

  // font size
  static double font10 = screenHeight / 68.34;
  static double font13 = screenHeight / 52.57;
  static double font14 = screenHeight / 48.81;
  static double font16 = screenHeight / 42.71;
  static double font25 = screenHeight / 27.33;

  // radius
  static double radius10 = screenHeight / 68.34;
  static double radius15 = screenHeight / 45.56;
  static double radius20 = screenHeight / 34.17;
}
