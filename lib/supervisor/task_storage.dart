import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'task.dart'; // Asegúrate de importar la clase Task

Future<File> _getLocalFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/tasks.json');
}

Future<List<Task>> loadTasks() async {
  try {
    final file = await _getLocalFile();
    final contents = await file.readAsString();
    final jsonData = json.decode(contents) as List;
    return jsonData.map((taskJson) => Task.fromJson(taskJson)).toList();
  } catch (e) {
    return []; // Si ocurre un error, devuelve una lista vacía
  }
}

Future<void> saveTasks(List<Task> tasks) async {
  final file = await _getLocalFile();
  final jsonData = tasks.map((task) => task.toJson()).toList();
  await file.writeAsString(json.encode(jsonData));
}
