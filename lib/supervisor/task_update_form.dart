import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore
import '../models/task.dart'; // Importa la clase Task
import 'package:intl/intl.dart'; // Importa intl para DateFormat

class TaskUpdateForm extends StatefulWidget {
  final Task task;

  const TaskUpdateForm({super.key, required this.task});

  @override
  _TaskUpdateFormState createState() => _TaskUpdateFormState();
}

class _TaskUpdateFormState extends State<TaskUpdateForm> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.task.description;
    _deadline = widget.task.deadline;
  }

  // Función para actualizar la tarea en Firestore
  Future<void> _updateTask() async {
    final updatedTask = Task(
      id: widget.task.id,
      description: _descriptionController.text,
      deadline: _deadline ?? DateTime.now(),
      isHighPriority: widget.task.isHighPriority,
      isMediumPriority: widget.task.isMediumPriority,
      isLowPriority: widget.task.isLowPriority,
      status: widget.task.status,
      assignedUser: widget.task.assignedUser,
    );

    // Actualizar la tarea en Firestore
    try {
      await FirebaseFirestore.instance
          .collection('tasks') // La colección de tareas en Firestore
          .doc(updatedTask.id) // Usar el ID de la tarea
          .update(updatedTask.toFirestore()); // Usar el método toFirestore para convertir la tarea

      Navigator.of(context).pop(updatedTask); // Cerrar el diálogo y devolver la tarea actualizada
    } catch (e) {
      print("Error al actualizar la tarea: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la tarea')),
      );
    }
  }

  // Función para eliminar la tarea actual en Firestore
  Future<void> _deleteTask() async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks') // La colección de tareas en Firestore
          .doc(widget.task.id) // Usar el ID de la tarea
          .delete(); // Eliminar la tarea

      Navigator.of(context).pop(null); // Cerrar el diálogo y devolver null
    } catch (e) {
      print("Error al eliminar la tarea: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la tarea')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tarea'),
      content: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción de la Tarea',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              const Text('Fecha Límite'),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Seleccionar fecha',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _deadline ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _deadline) {
                    setState(() {
                      _deadline = picked;
                    });
                  }
                },
                controller: TextEditingController(
                  text: _deadline != null ? _formatDate(_deadline!) : '',
                ),
              ),
              const SizedBox(height: 16),
              // Mostrar el usuario asignado pero no permitir edición
              Text(
                'Asignado a: ${widget.task.assignedUser.nombre} ${widget.task.assignedUser.apellido}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el diálogo sin actualizar
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _updateTask,
          child: const Text('Actualizar'),
        ),
        TextButton(
          onPressed: _deleteTask, // Botón para eliminar la tarea
          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}
