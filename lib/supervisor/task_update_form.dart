import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskUpdateForm extends StatefulWidget {
  final Task task;

  const TaskUpdateForm({super.key, required this.task, required String userId});

  @override
  _TaskUpdateFormState createState() => _TaskUpdateFormState();
}

class _TaskUpdateFormState extends State<TaskUpdateForm> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline;
  String _priority = 'Low';

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.task.description;
    _deadline = widget.task.deadline;

    if (widget.task.isHighPriority) {
      _priority = 'High';
    } else if (widget.task.isMediumPriority) {
      _priority = 'Medium';
    } else {
      _priority = 'Low';
    }
  }

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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedTask.assignedUserId)
          .collection('tasks')
          .doc(updatedTask.id)
          .update(updatedTask.toFirestore());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea actualizada exitosamente.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(updatedTask);
      }
    } catch (e) {
      print('Error al actualizar la tarea: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar la tarea: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.task.assignedUserId)
          .collection('tasks')
          .doc(widget.task.id)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea eliminada exitosamente.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(null);
      }
    } catch (e) {
      print('Error al eliminar la tarea: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar la tarea: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
    // Obtener el tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Editar Tarea',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
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
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha Límite',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _deadline != null
                        ? DateFormat('dd/MM/yyyy').format(_deadline!)
                        : 'Seleccionar fecha',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Prioridad',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: <Widget>[
                  ChoiceChip(
                    label: const Text('Alta'),
                    selected: _priority == 'High',
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) _priority = 'High';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Media'),
                    selected: _priority == 'Medium',
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) _priority = 'Medium';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Baja'),
                    selected: _priority == 'Low',
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) _priority = 'Low';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8.0,
                alignment: WrapAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}