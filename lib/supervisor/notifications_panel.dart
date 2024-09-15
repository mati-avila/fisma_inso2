import 'package:flutter/material.dart';

class NotificationsPanel extends StatefulWidget {
  const NotificationsPanel({super.key});

  @override
  _NotificationsPanelState createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel> {
  List<Notification> notifications = [
    Notification(
      title: 'Tarea vencida',
      message: 'La tarea asignada a Adrián Solís ha vencido.',
    ),
    Notification(
      title: 'Tarea vencida',
      message: 'La tarea asignada a Andrés Fariña ha vencido.',
    ),
    Notification(
      title: 'Recordatorio',
      message: 'No olvides enviar el informe semanal.',
    ),
    Notification(
      title: 'Actualización de sistema',
      message: 'El sistema estará en mantenimiento esta noche.',
    ),
  ];

  void _showNotificationDetails(Notification notification) {
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

class Notification {
  final String title;
  final String message;

  Notification({required this.title, required this.message});
}
