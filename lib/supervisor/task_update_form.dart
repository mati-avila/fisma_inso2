import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskUpdateForm extends StatefulWidget {
  final Task task;

  const TaskUpdateForm({super.key, required this.task});

  @override
  _TaskUpdateFormState createState() => _TaskUpdateFormState();
}

class _TaskUpdateFormState extends State<TaskUpdateForm> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline;
  String _priority = 'Low'; // Prioridad predeterminada

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.task.description;
    _deadline = widget.task.deadline;

    // Establecer la prioridad según la tarea existente
    if (widget.task.isHighPriority) {
      _priority = 'High';
    } else if (widget.task.isMediumPriority) {
      _priority = 'Medium';
    } else {
      _priority = 'Low';
    }
  }

  // Actualizar tarea
  Future<void> _updateTask() async {
    if (widget.task.id.isEmpty || widget.task.assignedUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: ID de tarea o usuario asignado vacío.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Establecer la prioridad según la opción seleccionada
      bool isHighPriority = _priority == 'High';
      bool isMediumPriority = _priority == 'Medium';
      bool isLowPriority = _priority == 'Low';

      final updatedTask = Task(
        id: widget.task.id,
        description: _descriptionController.text,
        deadline: _deadline ?? DateTime.now(),
        isHighPriority: isHighPriority,
        isMediumPriority: isMediumPriority,
        isLowPriority: isLowPriority,
        status: widget.task.status,
        assignedUserId: widget.task.assignedUserId,
      );

      // Actualización en la colección de tareas del usuario
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedTask.assignedUserId)
          .collection('tasks')
          .doc(updatedTask.id)
          .update(updatedTask.toFirestore());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarea actualizada exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(updatedTask);
    } catch (e) {
      print('Error al actualizar la tarea: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar la tarea: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Eliminar tarea
  Future<void> _deleteTask() async {
    if (widget.task.id.isEmpty || widget.task.assignedUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: ID de tarea o usuario asignado vacío.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Eliminación en la colección de tareas del usuario
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.task.assignedUserId)
          .collection('tasks')
          .doc(widget.task.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarea eliminada exitosamente.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(null);
    } catch (e) {
      print('Error al eliminar la tarea: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar la tarea: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Confirmar eliminación
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteTask();
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tarea'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción de la Tarea',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Fecha Límite',
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _deadline ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() => _deadline = pickedDate);
              }
            },
            controller: TextEditingController(
              text: _deadline != null
                  ? DateFormat('dd/MM/yyyy').format(_deadline!)
                  : '',
            ),
          ),
          const SizedBox(height: 16),
          // Prioridad de la tarea
          const Text(
            'Prioridad:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: const Text('Alta'),
            leading: Radio<String>(
              value: 'High',
              groupValue: _priority,
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Media'),
            leading: Radio<String>(
              value: 'Medium',
              groupValue: _priority,
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Baja'),
            leading: Radio<String>(
              value: 'Low',
              groupValue: _priority,
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _updateTask,
          child: const Text('Actualizar'),
        ),
        TextButton(
          onPressed: _showDeleteConfirmation,
          child: const Text(
            'Eliminar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
