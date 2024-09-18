import 'dart:async'; // Importa la librería para usar Timer
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task_storage.dart'; // Importa el almacenamiento de tareas
import 'task.dart'; // Importa la clase Task

class NotificationsPanel extends StatefulWidget {
  const NotificationsPanel({super.key});

  @override
  _NotificationsPanelState createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel> {
  List<NotificationItem> notifications = [];
  Timer? _timer; // Temporizador para las verificaciones periódicas

  @override
  void initState() {
    super.initState();
    _loadTasksAndCheckForDeadlines(); // Cargar las tareas al iniciar la pantalla

    // Configurar el temporizador para verificar las tareas cada 60 segundos
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _loadTasksAndCheckForDeadlines();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar el temporizador cuando se cierra la pantalla
    super.dispose();
  }

  Future<void> _loadTasksAndCheckForDeadlines() async {
    List<Task> tasks =
        await loadTasks(); // Cargar las tareas desde el almacenamiento local
    DateTime today = DateTime.now();

    setState(() {
      // Filtrar tareas que estén vencidas o venzan hoy
      notifications = tasks.where((task) {
        return task.deadline.isBefore(today) ||
            (task.deadline.year == today.year &&
                task.deadline.month == today.month &&
                task.deadline.day == today.day);
      }).map((task) {
        // Si la tarea ya venció, se muestra un mensaje distinto
        bool isOverdue = task.deadline.isBefore(today);
        return NotificationItem(
          title: isOverdue ? 'Tarea vencida' : 'Tarea a vencer hoy',
          message:
              'La tarea "${task.description}" ${isOverdue ? 'venció' : 'vence'} el ${DateFormat('dd/MM/yyyy').format(task.deadline)}.',
        );
      }).toList();
    });
  }

  void _showNotificationDetails(NotificationItem notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notification.title),
          content: Text(notification.message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  notifications.remove(notification);
                });
              },
              child: const Text('Aceptar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Notificaciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text('No hay notificaciones.'))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(notification.message),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => _showNotificationDetails(
                                          notification),
                                      child: const Text('Abrir'),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          notifications.remove(notification);
                                        });
                                      },
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String message;

  NotificationItem({required this.title, required this.message});
}
