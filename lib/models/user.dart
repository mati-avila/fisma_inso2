import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore Timestamp
import 'task.dart'; // Importar la clase Task

class User {
  String id;
  final String apellido;
  final String nombre;
  final String estado;
  final DateTime fechaUltimoAcceso;
  final String rol;
  final String contrasenia; // Campo para la contraseña
  final String correo; // Campo para el correo electrónico
  final String informeReciente; // Campo para el informe reciente
  final List<Task> tareas; // Lista de tareas asociadas al usuario

  User({
    required this.id,
    required this.apellido,
    required this.nombre,
    required this.estado,
    required this.fechaUltimoAcceso,
    required this.rol,
    required this.contrasenia,
    required this.correo,
    required this.informeReciente, // Nuevo campo
    required this.tareas, // Nuevo campo
  });

  // Convertir un User a un mapa JSON para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'apellido': apellido,
      'nombre': nombre,
      'estado': estado,
      'fechaUltimoAcceso': Timestamp.fromDate(fechaUltimoAcceso), // Convertir DateTime a Timestamp
      'rol': rol,
      'contraseña': contrasenia,
      'correo': correo,
      'informeReciente': informeReciente,
      'tareas': tareas.map((task) => task.toFirestore()).toList(), // Convertir lista de tareas a Firestore
    };
  }

  // Crear un User desde un documento de Firestore
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    var taskList = data['tareas'] as List? ?? [];
    List<Task> tasks = taskList.map((task) => Task.fromFirestore(task)).toList(); // Convertir las tareas
    
    return User(
      id: doc.id,
      apellido: data['apellido'] ?? '',
      nombre: data['nombre'] ?? '',
      estado: data['estado'] ?? '',
      fechaUltimoAcceso: (data['fechaUltimoAcceso'] as Timestamp).toDate(), // Convertir Timestamp a DateTime
      rol: data['rol'] ?? '',
      contrasenia: data['contraseña'] ?? '',
      correo: data['correo'] ?? '',
      informeReciente: data['informeReciente'] ?? '',
      tareas: tasks, // Recuperar las tareas
    );
  }

  
}
