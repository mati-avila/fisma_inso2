import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisma_inso2/models/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final String userId;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.userId,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.task.status;
  }

  Future<void> _updateTaskStatus(String newStatus) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('tasks')
        .doc(widget.task.id)
        .update({'status': newStatus});
    setState(() {
      status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles de la Tarea',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        color: Colors.teal.shade50,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.description,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Estado actual: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Chip(
                          label: Text(
                            status,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getStatusColor(status),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cambiar estado:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: status,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
                items: const [
                  DropdownMenuItem(
                      value: 'Pendiente', child: Text('Pendiente')),
                  DropdownMenuItem(
                      value: 'En progreso', child: Text('En progreso')),
                  DropdownMenuItem(
                      value: 'Completada', child: Text('Completada')),
                ],
                onChanged: (newValue) {
                  if (newValue != null) {
                    _updateTaskStatus(newValue);
                  }
                },
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      Task(
                        id: widget.task.id,
                        description: widget.task.description,
                        status: status,
                        isHighPriority: widget.task.isHighPriority,
                        isMediumPriority: widget.task.isMediumPriority,
                        deadline: widget.task.deadline,
                        isLowPriority: widget.task.isLowPriority,
                        assignedUserId: widget.task.assignedUserId,
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Guardar y regresar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pendiente':
        return Colors.orange;
      case 'En progreso':
        return Colors.blue;
      case 'Completada':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
