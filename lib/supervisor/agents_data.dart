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
    estadoDeTareas: 'Activo',
    fechaUltimoAcceso: 'Mayo 23, 2024',
    informeReciente: 'Informe 002',
  ),
  Agent(
    id: '003',
    nombre: 'Carlos',
    apellido: 'Pérez',
    estadoDeTareas: 'Activo',
    fechaUltimoAcceso: 'Mayo 22, 2024',
    informeReciente: 'Informe 003',
  ),
  Agent(
    id: '004',
    nombre: 'Laura',
    apellido: 'Mendez',
    estadoDeTareas: 'Activo',
    fechaUltimoAcceso: 'Mayo 21, 2024',
    informeReciente: 'Informe 004',
  ),
  Agent(
    id: '005',
    nombre: 'Luis',
    apellido: 'Rodriguez',
    estadoDeTareas: 'Activo',
    fechaUltimoAcceso: 'Mayo 20, 2024',
    informeReciente: 'Informe 005',
  ),
  Agent(
    id: '006',
    nombre: 'Maria',
    apellido: 'García',
    estadoDeTareas: 'Activo',
    fechaUltimoAcceso: 'Mayo 19, 2024',
    informeReciente: 'Informe 006',
  ),
  Agent(
    id: '007',
    nombre: 'Juan',
    apellido: 'Martinez',
    estadoDeTareas: 'Activo',
    fechaUltimoAcceso: 'Mayo 18, 2024',
    informeReciente: 'Informe 007',
  ),
  Agent(
    id: '008',
    nombre: 'Ana',
    apellido: 'Torres',
    estadoDeTareas: 'Activo',
    fechaUltimoAcceso: 'Mayo 17, 2024',
    informeReciente: 'Informe 008',
  ),
  Agent(
    id: '009',
    nombre: 'Pedro',
    apellido: 'Jiménez',
    estadoDeTareas: 'Activo',
    fechaUltimoAcceso: 'Mayo 16, 2024',
    informeReciente: 'Informe 009',
  ),
  Agent(
    id: '010',
    nombre: 'Isabel',
    apellido: 'Vásquez',
    estadoDeTareas: 'Activo',
    fechaUltimoAcceso: 'Mayo 15, 2024',
    informeReciente: 'Informe 010',
  ),
];
