import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sync_task/models/task.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
* Gestionnaire d'état des tâches
* Permet de récupérer, ajouter, modifier et supprimer des tâches
*/
class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];
  bool isLoading = true;
  final String apiUrl = dotenv.env['API_URL']!;

  /*
  * Récupère la liste des tâches depuis l'API
  */
  Future<void> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> taskJson = json.decode(response.body);
        tasks = taskJson.map((json) => Task.fromJson(json)).toList();
        isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Erreur lors du chargement des tâches');
      }
    } catch (e) {
      print('Erreur lors du chargement des tâches : $e');
      isLoading = false;
      notifyListeners();
    }
  }

  /*
  * Ajoute une tâche à la liste
  * @param newTask : Nouvelle tâche à ajouter
  */
  Future<void> addTask(Task newTask) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(newTask.toJson()),
    );
    if (response.statusCode == 200) {
      await fetchTasks();
    } else {
      throw Exception('Erreur lors de l\'ajout de la tâche');
    }
  }

  /*
  * Met à jour une tâche de la liste
  * @param updatedTask : Tâche mise à jour
  */
  Future<void> updateTask(Task updatedTask) async {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedTask.toJson()),
    );
    if (response.statusCode == 200) {
      await fetchTasks();
    } else {
      throw Exception('Erreur lors de la mise à jour de la tâche');
    }
  }

  /*
  * Supprime une tâche de la liste
  * @param taskId : ID de la tâche à supprimer
  */
  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'id': taskId}),
    );
    if (response.statusCode == 200) {
      await fetchTasks();
    } else {
      throw Exception('Erreur lors de la suppression de la tâche');
    }
  }
}
