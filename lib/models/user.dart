// lib/models/user.dart
import 'dart:convert';

class User {
  String id;
  final String apellido;
  final String nombre;
  final String estado;
  final DateTime fechaUltimoAcceso;
  final String rol;
  final String contrasenia; // Campo para la contraseña
  final String correo; // Campo para el correo electrónico

  User({
    required this.id,
    required this.apellido,
    required this.nombre,
    required this.estado,
    required this.fechaUltimoAcceso,
    required this.rol,
    required this.contrasenia, // Requerido
    required this.correo, // Requerido
  });

  // Convertir un User a un mapa JSON para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'apellido': apellido,
      'nombre': nombre,
      'estado': estado,
      'fechaUltimoAcceso': fechaUltimoAcceso.toIso8601String(),
      'rol': rol,
      'contraseña': contrasenia,
      'correo': correo,
    };
  }

  // Crear un User desde un documento de Firestore
  factory User.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      apellido: data['apellido'] ?? '',
      nombre: data['nombre'] ?? '',
      estado: data['estado'] ?? '',
      fechaUltimoAcceso: DateTime.parse(data['fechaUltimoAcceso']),
      rol: data['rol'] ?? '',
      contrasenia: data['contraseña'] ?? '',
      correo: data['correo'] ?? '',
    );
  }

  // Convertir un User a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apellido': apellido,
      'nombre': nombre,
      'estado': estado,
      'fechaUltimoAcceso': fechaUltimoAcceso.toIso8601String(),
      'rol': rol,
      'contraseña': contrasenia,
      'correo': correo,
    };
  }

  // Convertir un mapa JSON a un User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      apellido: json['apellido'],
      nombre: json['nombre'],
      estado: json['estado'],
      fechaUltimoAcceso: DateTime.parse(json['fechaUltimoAcceso']),
      rol: json['rol'],
      contrasenia: json['contraseña'],
      correo: json['correo'],
    );
  }
}
