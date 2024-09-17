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

  static List<User> decode(String usersJson) {
    final List<dynamic> parsed = json.decode(usersJson);
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  static String encode(List<User> users) {
    final List<Map<String, dynamic>> usersJson =
        users.map((user) => user.toJson()).toList();
    return json.encode(usersJson);
  }
}
