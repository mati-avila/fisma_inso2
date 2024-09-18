import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'task.dart'; // Asegúrate de importar la clase Task

// Guardar tareas en localStorage
Future<void> saveTasks(List<Task> tasks) async {
  final jsonData = tasks.map((task) => task.toJson()).toList();
  html.window.localStorage['tasks'] = json.encode(jsonData);
}

// Cargar tareas desde localStorage
Future<List<Task>> loadTasks() async {
  final tasksJson = html.window.localStorage['tasks'];
  if (tasksJson != null) {
    final jsonData = json.decode(tasksJson) as List;
    return jsonData.map((taskJson) => Task.fromJson(taskJson)).toList();
  } else {
    return []; // Si no hay datos, devolver una lista vacía
  }
}

// Eliminar una tarea por su ID en localStorage
Future<void> deleteTask(int taskId) async {
  List<Task> tasks = await loadTasks(); // Cargar tareas actuales
  tasks.removeWhere((task) => task.id == taskId); // Eliminar la tarea por su ID
  await saveTasks(tasks); // Guardar la lista actualizada
}
