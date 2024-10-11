import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sync_task/models/task.dart';
import 'package:sync_task/providers/task_provider.dart';

/*
* Affiche une boîte de dialogue pour ajouter une tâche
* Boite de dialogue = c'est une fenêtre qui s'affiche par dessus l'application
*/
Future<void> showAddTaskDialog(BuildContext context) async {
  String title = '';
  String description = '';
  String dueDate = '';

  /*
  * Affiche une modale pour ajouter une tâche
  */
  await showDialog(
    context: context,
    builder: (context) { // Fonction qui construit la modale
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
              onChanged: (value) => dueDate = value, // Récupération de la date
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Fermeture de la modale
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTask = Task(
                id: 0, // ID généré par l'API
                title: title,
                description: description,
                status: 'En attente',
                dueDate: dueDate,
              );
              Provider.of<TaskProvider>(context, listen: false).addTask(newTask); // Ajout de la tâche
              Navigator.of(context).pop(); // Fermeture de la modale
            },
            child: Text('Ajouter'),
          ),
        ],
      );
    },
  );
}

/*
* Affiche une modale pour modifier une tâche
*/
Future<void> showEditTaskDialog(BuildContext context, Task task) async {
  String title = task.title;
  String description = task.description;
  String dueDate = task.dueDate;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Modifier la tâche'),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Taille minimale
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Titre'),
              onChanged: (value) => title = value,
              controller: TextEditingController(text: title),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) => description = value,
              controller: TextEditingController(text: description),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Date limite (YYYY-MM-DD)'),
              onChanged: (value) => dueDate = value,
              controller: TextEditingController(text: dueDate),
            ),
          ],
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
                status: task.status,
                dueDate: dueDate,
              );
              Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask); // Mise à jour de la tâche
              Navigator.of(context).pop(); // Fermeture de la modale
            },
            child: Text('Modifier'),
          ),
        ],
      );
    },
  );
}
