// lib/models/user.dart
import 'dart:convert';

class User {
  final String id;
  final String apellido;
  final String nombre;
  final String estado;
  final DateTime fechaUltimoAcceso;
  final String rol;
  final String contrasenia; // Campo para la contraseña
  final String correo; // Nuevo campo para el correo electrónico

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

  // Convertir un User a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apellido': apellido,
      'nombre': nombre,
      'estado': estado,
      'fechaUltimoAcceso': fechaUltimoAcceso.toIso8601String(),
      'rol': rol,
      'contraseña': contrasenia, // Guardar la contraseña en JSON
      'correo': correo, // Guardar el correo en JSON
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
      contrasenia: json['contraseña'], // Cargar la contraseña desde JSON
      correo: json['correo'], // Cargar el correo desde JSON
    );
  }
}
