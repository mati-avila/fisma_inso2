import 'package:flutter/material.dart';
import 'task.dart'; // Importa la clase Task
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

  void _updateTask() {
    final updatedTask = Task(
      id: widget.task.id,
      description: _descriptionController.text,
      deadline: _deadline,
      isHighPriority: widget.task.isHighPriority,
      isMediumPriority: widget.task.isMediumPriority,
      isLowPriority: widget.task.isLowPriority,
      status: widget.task.status,
    );

    // Aquí deberías guardar los cambios de la tarea actualizada
    Navigator.of(context).pop(updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Actualizar Tarea'),
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
              // Otros campos y controles aquí
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
      ],
    );
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}