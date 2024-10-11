// Point d'entrée de l'application

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sync_task/providers/task_provider.dart';
import 'package:sync_task/screens/task_list_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Chargement des variables d'environnement
  await dotenv.load(fileName: ".env");

  // Lancement de l'application 
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider()..fetchTasks(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}
