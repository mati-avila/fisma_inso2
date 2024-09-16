import 'package:cloud_firestore/cloud_firestore.dart';

class Supervisor {
  final String nombre;
  final String apellido;
  final String fechaUltimoAcceso;
  final String rol;

  Supervisor({
    required this.nombre,
    required this.apellido,
    required this.fechaUltimoAcceso,
    required this.rol,
  });

  // Método para agregar supervisor a Firestore
  Future<void> addSupervisorToFirestore() async {
    await FirebaseFirestore.instance.collection('supervisors').add({
      'nombre': nombre,
      'apellido': apellido,
      'fechaUltimoAcceso': fechaUltimoAcceso,
      'rol': rol,
    });
  }
}
