import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.assignment),
          title: const Text('Asignación de tareas'),
          onTap: () {
            // Implementar navegación o lógica de asignación de tareas
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Configuración'),
          onTap: () {
            // Implementar lógica para configuración
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Cerrar sesión'),
          onTap: () {
            // Implementar funcionalidad de cerrar sesión
          },
        ),
      ],
    );
  }
}
