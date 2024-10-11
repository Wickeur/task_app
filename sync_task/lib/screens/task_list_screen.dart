import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sync_task/providers/task_provider.dart';
import 'package:sync_task/widgets/task_dialogs.dart';

/*
* Écran principal de l'application
*/
class TaskListScreen extends StatelessWidget {
  // Affiche une boîte de dialogue pour ajouter une tâche
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'application
      appBar: AppBar(
        title: Text('Liste de tâches'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showAddTaskDialog(context),
          ),
        ],
      ),

      // Corps de l'application
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          // Affiche une barre de progression si les tâches sont en cours de chargement
          if (taskProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // Affiche la liste des tâches
          return ListView.builder(

            // Nombre d'éléments dans la liste
            itemCount: taskProvider.tasks.length,

            // Affiche une carte pour chaque tâche
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index]; // Tâche courante

              return Card(
                child: ExpansionTile(
                  title: Text(task.title),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
                        children: [
                          Text('Description: ${task.description}'),
                          Text('Statut: ${task.status}'),
                          Text('Date limite: ${task.dueDate}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end, // Alignement à droite
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () =>
                                    showEditTaskDialog(context, task),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    taskProvider.deleteTask(task.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
