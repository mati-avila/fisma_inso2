import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fisma_inso2/models/task.dart';
import 'task_details_screen.dart'; // Importa la nueva pantalla

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  late String userId = ""; // Almacenar el ID del usuario

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar el usuario desde SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todas las Tareas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: userId.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Esperar hasta que se cargue el ID de usuario
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('tasks')
                  .snapshots(), // Escucha los cambios en tiempo real
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al obtener tareas: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay tareas disponibles',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }

                List<Task> tareas = snapshot.data!.docs
                    .map((doc) => Task.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: tareas.length,
                  itemBuilder: (context, index) {
                    final tarea = tareas[index];
                    return GestureDetector(
                      onTap: () async {
                        // Navegar a la pantalla de detalles y esperar cambios
                        final updatedTask = await Navigator.push<Task?>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                              task: tarea,
                              userId: userId,
                            ),
                          ),
                        );
                        if (updatedTask != null) {
                          // La tarea se actualiza automáticamente con StreamBuilder, no es necesario actualizarla manualmente.
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tarea.description,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Estado: ${tarea.status}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    tarea.isHighPriority
                                        ? "Prioridad: Alta"
                                        : tarea.isMediumPriority
                                            ? "Prioridad: Media"
                                            : "Prioridad: Baja",
                                    style: TextStyle(
                                      color: tarea.isHighPriority
                                          ? Colors.redAccent
                                          : tarea.isMediumPriority
                                              ? Colors.orangeAccent
                                              : Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
