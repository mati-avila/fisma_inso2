class Agent {
  final String id;
  final String nombre;
  final String apellido;
  final String estadoDeTareas;
  final String fechaUltimoAcceso;
  final String informeReciente;
  final String rol;  // Nuevo campo para rol

  Agent({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.estadoDeTareas,
    required this.fechaUltimoAcceso,
    required this.informeReciente,
    required this.rol,  // Asegúrate de pasar este parámetro al constructor
  });
}
