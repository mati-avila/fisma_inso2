import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa intl para DateFormat
import '../models/task.dart'; // Importar clase Task
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firebase Firestore
import 'task_update_form.dart'; // Importar formulario de actualización de tarea

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  _TasksListPageState createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _loadTasks(); // Cargar tareas desde Firestore
  }

  // Función para cargar las tareas desde Firestore
  Future<List<Task>> _loadTasks() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('tasks').get();
      return snapshot.docs
          .map((doc) => Task.fromFirestore(doc)) // Convertir cada documento a un objeto Task
          .toList();
    } catch (e) {
      print("Error al cargar las tareas: $e");
      return [];
    }
  }

  // Mostrar el formulario de actualización de tarea
  void _showUpdateTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TaskUpdateForm(task: task); // Proporcionar la tarea a actualizar
      },
    ).then((updatedTask) {
      if (updatedTask != null) {
        setState(() {
          _tasksFuture = _loadTasks(); // Actualizar la lista de tareas después de cambios o eliminación
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay tareas disponibles.'));
          }

          List<Task> tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task.description),
                subtitle: Text('Fecha límite: ${_formatDate(task.deadline)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showUpdateTaskDialog(task),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Formato de fecha para mostrar en la lista
  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}
