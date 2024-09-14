import 'package:flutter/material.dart';

class NotificationsPanel extends StatelessWidget {
  const NotificationsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
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
        const Divider(),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                title: const Text('Tarea vencida'),
                subtitle:
                    const Text('La tarea asignada a Adrián Solís ha vencido.'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Aceptar')),
                    TextButton(onPressed: () {}, child: const Text('Abrir')),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Tarea por vencer'),
                subtitle: const Text(
                    'La tarea asignada a Andrés Fariña está por vencer.'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Aceptar')),
                    TextButton(onPressed: () {}, child: const Text('Abrir')),
                  ],
                ),
              ),
              // Agregar más notificaciones según sea necesario
            ],
          ),
        ),
      ],
    );
  }
}
