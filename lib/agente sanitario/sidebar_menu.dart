import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sección de Configuración
        ExpansionTile(
          leading: const Icon(Icons.settings),
          title: const Text('Configuración'),
          children: const [
            ListTile(
              title: Text('Ajustes Generales'),
            ),
            ListTile(
              title: Text('Preferencias'),
            ),
          ],
        ),
        const SizedBox(height: 16), // Espacio entre las secciones

        // Sección de Últimas Notificaciones
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Últimas Notificaciones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8), // Espacio entre el título y las notificaciones
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Notificación 1'),
                      ),
                      ListTile(
                        title: Text('Notificación 2'),
                      ),
                      // Aquí puedes agregar más ListTile para otras notificaciones
                    ],
                  ),
                ),
                const SizedBox(height: 8), // Espacio antes de la sección de ver todas las tareas
                ElevatedButton(
                  onPressed: () {
                    // Acción para ver todas las tareas
                  },
                  child: const Text('Ver todas las tareas'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
