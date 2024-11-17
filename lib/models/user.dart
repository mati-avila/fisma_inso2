import 'package:cloud_firestore/cloud_firestore.dart';
import 'task.dart';

class User {
  String id;
  final String apellido;
  final String nombre;
  final String estado;
  final DateTime fechaUltimoAcceso;
  final String rol;
  final String contrasenia;
  final String correo;
  final String informeReciente;
  List<Task> tareas;

  User({
    required this.id,
    required this.apellido,
    required this.nombre,
    required this.estado,
    required this.fechaUltimoAcceso,
    required this.rol,
    required this.contrasenia,
    required this.correo,
    required this.informeReciente,
    required this.tareas,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'apellido': apellido,
      'nombre': nombre,
      'estado': estado,
      'fechaUltimoAcceso': Timestamp.fromDate(fechaUltimoAcceso),
      'rol': rol,
      'contraseña': contrasenia,
      'correo': correo,
      'informeReciente': informeReciente,
      'tareas': tareas.map((task) => task.toFirestore()).toList(),
    };
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Manejo seguro de la fecha
    DateTime fecha;
    try {
      fecha = (data['fechaUltimoAcceso'] as Timestamp?)?.toDate() ?? DateTime.now();
    } catch (e) {
      fecha = DateTime.now();
    }

    // Manejo seguro de las tareas
    List<Task> taskList = [];
    try {
      if (data['tareas'] != null) {
        final tasksData = data['tareas'] as List<dynamic>;
        taskList = tasksData.map((taskData) {
          if (taskData is Map<String, dynamic>) {
            return Task.fromMap(taskData);
          }
          return Task.empty();
        }).toList();
      }
    } catch (e) {
      print('Error al convertir tareas: $e');
    }

    return User(
      id: doc.id,
      apellido: data['apellido'] ?? '',
      nombre: data['nombre'] ?? '',
      estado: data['estado'] ?? '',
      fechaUltimoAcceso: fecha,
      rol: data['rol'] ?? '',
      contrasenia: data['contraseña'] ?? '',
      correo: data['correo'] ?? '',
      informeReciente: data['informeReciente'] ?? '',
      tareas: taskList,
    );
  }
}