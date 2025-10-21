import 'package:clean_todo_tdd/di/di_config.dart';
import 'package:flutter/material.dart';

import 'features/todos/ui/screens/home/home_screen.dart';

void main() {
  configureDependencies();

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
