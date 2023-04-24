import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/db/db_helper.dart';
import 'package:todo_app/routes/route_helper.dart';
import 'package:todo_app/theme/theme.dart';
import 'services/theme_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB(); // init database
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light, // The default mode
      themeMode:
          ThemeServices().theme, // themeMode.dark calls darkTheme property
      darkTheme: Themes.dark,
      initialRoute: RouteHelper.getInitial(),
      getPages: RouteHelper.routes,
    );
  }
}
