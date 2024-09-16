import 'package:flutter/material.dart';
import 'agents_list_page.dart'; // Asegúrate de importar la página de la lista de agentes
import 'tasks_list_page.dart';
import 'config_dialog.dart'; // Importar el diálogo de configuración

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 17.0), // Ajusta el padding superior según sea necesario
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Asignación de tareas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AgentsListPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Listado de tareas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TasksListPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              // Abrir el pop-up de configuración
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const ConfigDialog();
                },
              );
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
      ),
    );
  }
}
