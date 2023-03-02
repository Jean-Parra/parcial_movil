// ignore_for_file: library_private_types_in_public_api, avoid_print
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'list.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => const LoginScreen()),
        GetPage(name: "/pagina-dos", page: () => const ListScreen()),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      print("token vacio");
      Get.to(() => const LoginScreen());
    } else {
      print("token lleno");
      Get.to(() => const ListScreen());
    }
  }
}
