import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/user.dart'; // Tu modelo de usuario
import 'task_assignment_form.dart'; // Formulario para asignación de tareas

class AgentsListPage extends StatefulWidget {
  const AgentsListPage({super.key});

  @override
  _AgentsListPageState createState() => _AgentsListPageState();
}

class _AgentsListPageState extends State<AgentsListPage> {
  Set<User> selectedUsers = {}; // Conjunto de usuarios seleccionados (solo uno permitido)
  int _taskIdCounter = 1; // Contador para generar IDs de tareas
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  List<User> filteredUsers = []; // Usuarios filtrados según la búsqueda

  // Referencia a la colección de usuarios en Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _usersCollection;

  @override
  void initState() {
    super.initState();
    _usersCollection = _firestore.collection('users'); // Colección de usuarios
    _loadUsers(); // Cargar usuarios de Firestore
  }

  // Método para cargar usuarios desde Firestore
  Future<void> _loadUsers() async {
    try {
      QuerySnapshot snapshot = await _usersCollection.get();
      setState(() {
        filteredUsers = snapshot.docs.map((doc) {
          return User.fromFirestore(doc);
        }).toList();
      });
    } catch (e) {
      print('Error al cargar usuarios: $e');
    }
  }

  // Método de búsqueda
  void _filterUsers() {
    setState(() {
      filteredUsers = filteredUsers.where((user) {
        return user.nombre.toLowerCase().contains(nombreController.text.toLowerCase()) &&
               user.apellido.toLowerCase().contains(apellidoController.text.toLowerCase());
      }).toList();
    });
  }

  void _showTaskAssignmentDialog() {
    if (selectedUsers.isNotEmpty) {
      // Mostrar formulario de asignación de tareas si se selecciona un usuario
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final taskId = (_taskIdCounter++).toString();
          return TaskAssignmentForm(
            user: selectedUsers.first, // Pasar el usuario seleccionado
            taskId: taskId,
          );
        },
      );
    } else {
      // Si no hay usuario seleccionado, mostrar advertencia
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Advertencia'),
            content: const Text('Por favor, seleccione un usuario.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800; // Para pantallas grandes

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignación de Tareas'),
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 32.0 : 16.0, // Ajuste de márgenes
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centra el contenido
          children: [
            // Campos de búsqueda
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Buscar por Nombre',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _filterUsers(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: apellidoController,
                      decoration: const InputDecoration(
                        labelText: 'Buscar por Apellido',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _filterUsers(),
                    ),
                  ),
                ],
              ),
            ),
            // Contenedor con desplazamiento horizontal y vertical
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Habilita scroll vertical
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Habilita scroll horizontal
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidth - 32,
                    ),
                    child: SizedBox(
                      width: screenWidth, // Ajusta el ancho de la tabla
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Apellido')),
                          DataColumn(label: Text('Estado')),
                          DataColumn(label: Text('Rol')),
                        ],
                        rows: filteredUsers.map((user) {
                          return DataRow(
                            selected: selectedUsers.contains(user),
                            onSelectChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  selectedUsers.clear(); // Limpiar selección anterior
                                  selectedUsers.add(user); // Seleccionar nuevo usuario
                                } else {
                                  selectedUsers.remove(user); // Desmarcar usuario
                                }
                              });
                            },
                            cells: [
                              DataCell(Text(user.nombre)),
                              DataCell(Text(user.apellido)),
                              DataCell(Text(user.estado)),
                              DataCell(Text(user.rol)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: isLargeScreen ? 250 : 200, // Ancho del botón ajustable
              child: ElevatedButton(
                onPressed: _showTaskAssignmentDialog,
                child: const Text('Asignar Tarea'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16), // Ajusta el alto del botón
                  textStyle: TextStyle(
                    fontSize: isLargeScreen ? 20 : 18, // Ajuste de tamaño de texto
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
