class User {
  final String id; // Este campo será generado automáticamente.
  final String apellido;
  final String nombre;
  final String estado; // Puede ser 'pendiente' o 'completo'.
  final DateTime fechaUltimoAcceso;
  final String rol; // Puede ser 'Agente Sanitario' o 'Supervisor'.

  User({
    required this.id,
    required this.apellido,
    required this.nombre,
    required this.estado,
    required this.fechaUltimoAcceso,
    required this.rol,
  });
}
