import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisma_inso2/models/task.dart';
import 'package:fisma_inso2/models/user.dart';

class TaskAssignmentForm extends StatefulWidget {
  final String taskId; // ID de tarea
  final User user; // Información del usuario

  const TaskAssignmentForm({
    super.key,
    required this.user,
    required this.taskId, // Requiere ID de tarea
  });

  @override
  _TaskAssignmentFormState createState() => _TaskAssignmentFormState();
}

class _TaskAssignmentFormState extends State<TaskAssignmentForm> {
  bool _isHighPriority = false;
  bool _isMediumPriority = false;
  bool _isLowPriority = false;
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline;

  void _resetForm() {
    setState(() {
      _isHighPriority = false;
      _isMediumPriority = false;
      _isLowPriority = false;
      _descriptionController.clear();
      _deadline = null;
    });
  }

  // Método para agregar la tarea al usuario en Firestore
  Future<void> addTaskToUser(Task task) async {
  try {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.id)
        .collection('tasks')
        .doc(); // Este ID será generado automáticamente por Firestore

    // Asigna el ID generado a la tarea
    task.id = userDoc.id;

    // Guarda la tarea en Firestore
    await userDoc.set(task.toFirestore());
    print("Tarea asignada con éxito: ${task.id}");
  } catch (e) {
    print("Error al asignar tarea al usuario: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al asignar tarea: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Asignar Tarea'),
      content: SizedBox(
        width: 500, // Ajusta el ancho aquí
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('ID de Tarea: ${widget.taskId}'), // Mostrar ID de tarea
              const SizedBox(height: 16),
              Text('Usuario: ${widget.user.nombre} ${widget.user.apellido}'), // Mostrar nombre del usuario
              const SizedBox(height: 16),
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
                controller: TextEditingController(
                  text: _deadline != null ? _formatDate(_deadline!) : '',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Prioridad',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('ALTA'),
                      value: _isHighPriority,
                      onChanged: (bool? value) {
                        setState(() {
                          _isHighPriority = value ?? false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('MEDIA'),
                      value: _isMediumPriority,
                      onChanged: (bool? value) {
                        setState(() {
                          _isMediumPriority = value ?? false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('BAJA'),
                      value: _isLowPriority,
                      onChanged: (bool? value) {
                        setState(() {
                          _isLowPriority = value ?? false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Estado: Pendiente',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el diálogo
            _resetForm(); // Reiniciar el formulario al cancelar
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
  onPressed: () async {
    String priority = 'Baja'; // Prioridad por defecto

    if (_isHighPriority) {
      priority = 'Alta';
    } else if (_isMediumPriority) {
      priority = 'Media';
    }

    // Crear la nueva tarea sin el ID, ya que se generará automáticamente
    final newTask = Task(
      id: '', // Esto será asignado después
      description: _descriptionController.text,
      deadline: _deadline ?? DateTime.now(),
      isHighPriority: _isHighPriority,
      isMediumPriority: _isMediumPriority,
      isLowPriority: _isLowPriority,
      status: 'Pendiente',
      assignedUserId: widget.user.id,
    );

    // Asignar la tarea al usuario
    await addTaskToUser(newTask);

    // Cerrar el diálogo y resetear el formulario
    Navigator.of(context).pop(newTask);
    _resetForm();
  },
  child: const Text('Asignar'),
),

      ],
    );
  }

  // Función para formatear la fecha
  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}
