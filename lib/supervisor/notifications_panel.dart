import 'package:flutter/material.dart';

class NotificationsPanel extends StatelessWidget {
  const NotificationsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Notificaciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Divider(),

        // Aquí aseguramos que la lista sea desplazable y que ocupe el espacio correcto
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                NotificationTile(
                  title: 'Tarea vencida',
                  subtitle: 'La tarea asignada a Adrián Solís ha vencido.',
                ),
                NotificationTile(
                  title: 'Tarea por vencer',
                  subtitle:
                      'La tarea asignada a Andrés Fariña está por vencer.',
                ),
                // Agregar más notificaciones según sea necesario
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const NotificationTile({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8.0),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Aceptar'),
              ),
              const SizedBox(width: 8.0),
              TextButton(
                onPressed: () {},
                child: const Text('Abrir'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
