import 'dart:convert';

class User {
  final String id;
  final String apellido;
  final String nombre;
  final String estado;
  final DateTime fechaUltimoAcceso;
  final String rol;

  User({
    required this.id,
    required this.apellido,
    required this.nombre,
    required this.estado,
    required this.fechaUltimoAcceso,
    required this.rol,
  });

  // Convertir un User a un mapa de JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apellido': apellido,
      'nombre': nombre,
      'estado': estado,
      'fechaUltimoAcceso': fechaUltimoAcceso.toIso8601String(),
      'rol': rol,
    };
  }

  // Crear un User desde un mapa de JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      apellido: json['apellido'],
      nombre: json['nombre'],
      estado: json['estado'],
      fechaUltimoAcceso: DateTime.parse(json['fechaUltimoAcceso']),
      rol: json['rol'],
    );
  }

  // Codificar lista de usuarios en JSON
  static String encode(List<User> users) {
    return json.encode(users.map((user) => user.toJson()).toList());
  }

  // Decodificar lista de usuarios desde JSON
  static List<User> decode(String usersJson) {
    final List<dynamic> userList = json.decode(usersJson);
    return userList.map((json) => User.fromJson(json)).toList();
  }
}
