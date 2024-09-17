
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import 'package:validators/validators.dart' as validator;
import 'task.dart'; // Importa la clase Task
import 'agents_data.dart';
import 'task_storage.dart'; // Asegúrate de importar las funciones de almacenamiento de tareas

class TaskAssignmentForm extends StatefulWidget {
  final String taskId; // Agregar ID de tarea
  final Agent agent; // Información del agente

  const TaskAssignmentForm({
    super.key,
    required this.agent,
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

  // Método para agregar una tarea
  Future<void> addTask(Task task) async {
    List<Task> tasks = await loadTasks(); // Cargar tareas actuales
    tasks.add(task); // Añadir la nueva tarea a la lista
    await saveTasks(tasks); // Guardar la lista actualizada
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
              Text('Agente: ${widget.agent.nombre} ${widget.agent.apellido}'),
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
            // Validar que taskId sea numérico
            if (validator.isNumeric(widget.taskId)) {
              // Crear la nueva tarea si el taskId es válido
              final newTask = Task(
                id: int.parse(widget.taskId), // Convierte taskId a int
                description: _descriptionController.text,
                deadline: _deadline ?? DateTime.now(),
                isHighPriority: _isHighPriority,
                isMediumPriority: _isMediumPriority,
                isLowPriority: _isLowPriority,
                status: 'Pendiente',
              );

              // Guardar la tarea aquí y cerrar el diálogo
              await addTask(newTask);
              Navigator.of(context).pop(newTask);
              _resetForm(); // Reiniciar el formulario después de asignar la tarea
            } else {
              // Mostrar un mensaje de error si el taskId no es válido
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ID de Tarea no válido. Debe ser un número.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
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