class Agent {
  final String id;
  final String nombre;
  final String apellido;
  final String estadoDeTareas;
  final String fechaUltimoAcceso;
  final String informeReciente;

  Agent({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.estadoDeTareas,
    required this.fechaUltimoAcceso,
    required this.informeReciente,
  });
}

List<Agent> agentes = [
  Agent(
    id: '001',
    nombre: 'Adrian',
    apellido: 'Solis',
    estadoDeTareas: 'Activo',
    fechaUltimoAcceso: 'Mayo 24, 2024',
    informeReciente: 'Informe 001',
  ),
  Agent(
    id: '002',
    nombre: 'Andrea',
    apellido: 'Farfan',
    estadoDeTareas: 'En curso',
    fechaUltimoAcceso: 'Mayo 23, 2024',
    informeReciente: 'Informe 002',
  ),
  // Agrega más agentes aquí según necesites.
];
