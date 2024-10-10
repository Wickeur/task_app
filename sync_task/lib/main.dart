import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Modèle pour les tâches
class Task {
  final int id;
  final String title;
  final String description;
  final String status;
  final String dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
  });

  // Factory pour créer une instance à partir d'un JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      dueDate: json['due_date'],
    );
  }

  // Convertir une tâche en JSON (pour les requêtes POST et PUT)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'due_date': dueDate,
    };
  }
}

void main() => runApp(MyApp());

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

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  bool isLoading = true;

  // Variable contenant l'URL de l'API
  final String apiUrl = 'https://aa59-79-174-199-110.ngrok-free.app/';

  // Fonction pour récupérer les tâches depuis l'API
  Future<void> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> taskJson = json.decode(response.body);
        setState(() {
          tasks = taskJson.map((json) => Task.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Erreur lors du chargement des tâches');
      }
    } catch (e) {
      print('Erreur lors du chargement des tâches : $e');
    }
  }

  // Ajouter une nouvelle tâche
  Future<void> addTask(Task newTask) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(newTask.toJson()),
    );

    if (response.statusCode == 200) {
      fetchTasks(); // Recharger la liste des tâches après ajout
    } else {
      throw Exception('Erreur lors de l\'ajout de la tâche');
    }
  }

  // Mettre à jour une tâche
  Future<void> updateTask(Task updatedTask) async {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedTask.toJson()),
    );

    if (response.statusCode == 200) {
      fetchTasks(); // Recharger la liste des tâches après modification
    } else {
      throw Exception('Erreur lors de la mise à jour de la tâche');
    }
  }

  // Supprimer une tâche
  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'id': taskId}),
    );

    if (response.statusCode == 200) {
      fetchTasks(); // Recharger la liste des tâches après suppression
    } else {
      throw Exception('Erreur lors de la suppression de la tâche');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de tâches'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTaskDialog(context), // Ouvrir le dialogue pour ajouter une nouvelle tâche
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.description),
                        Text('Statut : ${task.status}'),
                        Text('Date limite : ${task.dueDate}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditTaskDialog(context, task), // Modifier la tâche
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteTask(task.id), // Supprimer la tâche
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Boîte de dialogue pour ajouter une nouvelle tâche
  Future<void> _showAddTaskDialog(BuildContext context) async {
    String title = '';
    String description = '';
    String status = 'en_attente';
    String dueDate = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter une nouvelle tâche'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Titre'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Date limite (YYYY-MM-DD)'),
                onChanged: (value) => dueDate = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                final newTask = Task(
                  id: 0, // L'API générera l'ID
                  title: title,
                  description: description,
                  status: status,
                  dueDate: dueDate,
                );
                addTask(newTask);
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  // Boîte de dialogue pour modifier une tâche
Future<void> _showEditTaskDialog(BuildContext context, Task task) async {
    String title = task.title;
    String description = task.description;
    String status = task.status;
    String dueDate = task.dueDate;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier la tâche'),
          content: SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Titre'),
                onChanged: (value) => title = value,
                controller: TextEditingController(text: task.title),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
                controller: TextEditingController(text: task.description),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Date limite (YYYY-MM-DD)'),
                onChanged: (value) => dueDate = value,
                controller: TextEditingController(text: task.dueDate),
              ),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(labelText: 'Statut'),
                  items: [
                    DropdownMenuItem(
                      value: 'En attente',
                      child: Text('En attente'),
                    ),
                    DropdownMenuItem(
                      value: 'En cours',
                      child: Text('En cours'),
                    ),
                    DropdownMenuItem(
                      value: 'Terminée',
                      child: Text('Terminée'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        status = value;
                      });
                    }
                  },
                ),
            ],
          ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedTask = Task(
                  id: task.id,
                  title: title,
                  description: description,
                  status: status,
                  dueDate: dueDate,
                );
                updateTask(updatedTask);
                Navigator.of(context).pop();
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }
}
