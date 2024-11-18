import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisma_inso2/agente%20sanitario/all_tasks_screen.dart';
import 'package:fisma_inso2/models/task.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({super.key});

  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  late String userId= "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de Configuración
                  const Text(
                    'Configuración',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.blueAccent),
                    title: const Text('Ajustes Generales',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      // Acción para Ajustes Generales
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.tune, color: Colors.blueAccent),
                    title: const Text('Preferencias',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      // Acción para Preferencias
                    },
                  ),
                  const Divider(thickness: 1, height: 32),

                  // Sección de Últimas Notificaciones
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('tasks')
                        .snapshots(), // Aquí usamos snapshots para escuchar cambios en tiempo real
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error al cargar tareas'));
                      }

                      final tareas = snapshot.data?.docs
                          .map((doc) => Task.fromFirestore(doc))
                          .toList() ?? [];

                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Últimas Notificaciones',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            tareas.isEmpty
                                ? Expanded(
                                    child: Center(
                                      child: Text(
                                        'No hay tareas asignadas',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      itemCount: tareas.length,
                                      itemBuilder: (context, index) {
                                        final tarea = tareas[index];
                                        return Card(
                                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tarea.description,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Estado: ${tarea.status}',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                Text(
                                                  'Prioridad: ${tarea.isHighPriority ? "Alta" : tarea.isMediumPriority ? "Media" : "Baja"}',
                                                  style: TextStyle(
                                                    color: tarea.isHighPriority
                                                        ? Colors.redAccent
                                                        : tarea.isMediumPriority
                                                            ? Colors.orangeAccent
                                                            : Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AllTasksScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Ver todas las tareas'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
