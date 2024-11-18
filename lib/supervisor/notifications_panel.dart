import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../models/user.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;

  const NotificationsScreen({super.key, required this.userId});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadAllAgentTasksAndCheckDeadlines();

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _loadAllAgentTasksAndCheckDeadlines();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadAllAgentTasksAndCheckDeadlines() async {
    try {
      // 1. Obtener todos los usuarios que son Agentes Sanitarios
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('rol', isEqualTo: 'Agente Sanitario')
          .get();

      List<NotificationItem> allNotifications = [];
      DateTime today = DateTime.now();

      // 2. Para cada Agente Sanitario, obtener sus tareas
      for (var userDoc in userSnapshot.docs) {
        User user = User.fromFirestore(userDoc);

        // Obtener las tareas del usuario desde la subcolección 'tasks'
        QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('tasks')
            .get();

        List<Task> tasks = taskSnapshot.docs
            .map((doc) {
              // Asegurarse de que la fecha sea un Timestamp y convertirla a DateTime
              Task task = Task.fromFirestore(doc);
              if (task.deadline is Timestamp) {
                task.deadline = (task.deadline as Timestamp).toDate();
              }
              return task;
            })
            .where((task) {
              DateTime taskDeadline = task.deadline; // Ya convertido a DateTime
              return taskDeadline.isBefore(today) || taskDeadline.isAtSameMomentAs(today);
            })
            .toList();

        // Crear notificaciones para las tareas vencidas o por vencer
        for (var task in tasks) {
          DateTime taskDeadline = task.deadline;
          bool isOverdue = taskDeadline.isBefore(today);
          allNotifications.add(
            NotificationItem(
              title: isOverdue ? 'Tarea vencida' : 'Tarea a vencer hoy',
              message:
                  'La tarea "${task.description}" ${isOverdue ? 'venció' : 'vence'} el ${DateFormat('dd/MM/yyyy').format(taskDeadline)}.\nAsignada a: ${user.nombre} ${user.apellido}',
              isOverdue: isOverdue,
              agentName: '${user.nombre} ${user.apellido}',
              priority: task.isHighPriority
                  ? 'Alta'
                  : task.isMediumPriority
                      ? 'Media'
                      : 'Baja',
            ),
          );
        }
      }

      // Ordenar notificaciones: primero las vencidas, luego por prioridad
      allNotifications.sort((a, b) {
        if (a.isOverdue != b.isOverdue) {
          return a.isOverdue ? -1 : 1;
        }
        return _getPriorityValue(a.priority).compareTo(_getPriorityValue(b.priority));
      });

      setState(() {
        notifications = allNotifications;
      });
    } catch (e) {
      print('Error al cargar las tareas: $e');
    }
  }

  int _getPriorityValue(String priority) {
    switch (priority) {
      case 'Alta':
        return 0;
      case 'Media':
        return 1;
      case 'Baja':
        return 2;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones de Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No hay tareas vencidas o por vencer.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notification.isOverdue
                        ? Colors.red[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: notification.isOverdue
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: notification.isOverdue
                            ? Colors.red
                            : Colors.orange,
                        child: Icon(
                          notification.isOverdue
                              ? Icons.warning
                              : Icons.event,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: notification.isOverdue
                                        ? Colors.red
                                        : Colors.orange,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(notification.priority),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Prioridad ${notification.priority}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.message,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Agente: ${notification.agentName}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red[700]!; 
      case 'Media':
        return Colors.orange[700]!; 
      case 'Baja':
        return Colors.green[700]!; 
      default:
        return Colors.grey;
    }
  }
}

class NotificationItem {
  final String title;
  final String message;
  final bool isOverdue;
  final String agentName;
  final String priority;

  NotificationItem({
    required this.title,
    required this.message,
    required this.isOverdue,
    required this.agentName,
    required this.priority,
  });
}
