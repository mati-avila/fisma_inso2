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
