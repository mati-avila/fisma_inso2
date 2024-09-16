import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  final String id;
  final String nombre;
  final String apellido;
  final String estadoDeTareas;
  final String fechaUltimoAcceso;
  final String informeReciente;
  final String rol;

  Agent({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.estadoDeTareas,
    required this.fechaUltimoAcceso,
    required this.informeReciente,
    required this.rol,
  });

  // Método para agregar agente a Firestore
  Future<void> addAgentToFirestore() async {
    await FirebaseFirestore.instance.collection('agents').doc(id).set({
      'nombre': nombre,
      'apellido': apellido,
      'estadoDeTareas': estadoDeTareas,
      'fechaUltimoAcceso': fechaUltimoAcceso,
      'informeReciente': informeReciente,
      'rol': rol,
    });
  }
}
