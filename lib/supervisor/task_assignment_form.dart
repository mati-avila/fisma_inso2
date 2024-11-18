import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisma_inso2/models/task.dart';
import 'package:fisma_inso2/models/user.dart';

class TaskAssignmentForm extends StatefulWidget {
  final String taskId;
  final User user;

  const TaskAssignmentForm({
    super.key,
    required this.user,
    required this.taskId,
  });

  @override
  _TaskAssignmentFormState createState() => _TaskAssignmentFormState();
}

class _TaskAssignmentFormState extends State<TaskAssignmentForm> {
  String _priority = 'low'; // Nuevo: usar un solo string para prioridad
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline;

  void _resetForm() {
    setState(() {
      _priority = 'low';
      _descriptionController.clear();
      _deadline = null;
    });
  }

  Future<void> addTaskToUser(Task task) async {
    try {
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.id)
          .collection('tasks')
          .doc();

      task.id = userDoc.id;
      await userDoc.set(task.toFirestore());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea asignada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Error al asignar tarea al usuario: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al asignar tarea: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                'Asignar Tarea',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Información de ID y Usuario
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${widget.taskId}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Usuario: ${widget.user.nombre} ${widget.user.apellido}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Campo de descripción
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción de la Tarea',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Selector de fecha
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _deadline) {
                    setState(() {
                      _deadline = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha Límite',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _deadline != null ? _formatDate(_deadline!) : 'Seleccionar fecha',
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Selector de prioridad
              const Text(
                'Prioridad',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: <Widget>[
                  ChoiceChip(
                    label: const Text('ALTA'),
                    selected: _priority == 'high',
                    selectedColor: Colors.red[100],
                    onSelected: (bool selected) {
                      setState(() => _priority = selected ? 'high' : 'low');
                    },
                  ),
                  ChoiceChip(
                    label: const Text('MEDIA'),
                    selected: _priority == 'medium',
                    selectedColor: Colors.orange[100],
                    onSelected: (bool selected) {
                      setState(() => _priority = selected ? 'medium' : 'low');
                    },
                  ),
                  ChoiceChip(
                    label: const Text('BAJA'),
                    selected: _priority == 'low',
                    selectedColor: Colors.green[100],
                    onSelected: (bool selected) {
                      setState(() => _priority = selected ? 'low' : 'medium');
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Estado
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Estado: Pendiente',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botones de acción
              Wrap(
                spacing: 8.0,
                alignment: WrapAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetForm();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newTask = Task(
                        id: '',
                        description: _descriptionController.text,
                        deadline: _deadline ?? DateTime.now(),
                        isHighPriority: _priority == 'high',
                        isMediumPriority: _priority == 'medium',
                        isLowPriority: _priority == 'low',
                        status: 'Pendiente',
                        assignedUserId: widget.user.id,
                      );

                      await addTaskToUser(newTask);
                      if (mounted) {
                        Navigator.of(context).pop(newTask);
                      }
                      _resetForm();
                    },
                    child: const Text('Asignar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}