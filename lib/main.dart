import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/controller/category_controller.dart';
import 'package:todo/controller/settings_controller.dart';
import 'package:todo/controller/task_controller.dart';
import 'package:todo/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyBE1ypueyILwpUI83jTOWAaGGXjtBUBQjY',
        appId: 'todo-808c4',
        messagingSenderId: '844015999298',
        projectId: 'todo-808c4'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthController(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryController(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsController(),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
            useMaterial3: true,
          ),
          home: const SplashScreen()),
    );
  }
}
