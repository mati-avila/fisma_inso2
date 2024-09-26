class Formulario {
  final String idVisita;
  final String idFamilia;
  final String numSector;
  final String numCasa;
  final String nomTitular;
  final String direccion;
  final String numTelefono;
  final String? tipoCasa;
  final String? tipoFamilia;
  final String coordinates;
  final Map<String, String>
      resultados; // Para almacenar los resultados de checkbox

  Formulario({
    required this.idVisita,
    required this.idFamilia,
    required this.numSector,
    required this.numCasa,
    required this.nomTitular,
    required this.direccion,
    required this.numTelefono,
    this.tipoCasa,
    this.tipoFamilia,
    required this.coordinates,
    required this.resultados,
  });
}

// Ejemplo de lista con formularios guardados
List<Formulario> formularios = [
  Formulario(
    idVisita: '001',
    idFamilia: '034',
    numSector: '010',
    numCasa: '007',
    nomTitular: 'Juan Pérez',
    direccion: 'Av. Hipólito Yrigoyen 150',
    numTelefono: '3885002949',
    tipoCasa: 'Casa Nueva (CN)',
    tipoFamilia: 'Unipersonal',
    coordinates: '-24.190140,-65.290114',
    resultados: {
      'Discapacidad':
          'Dificultad para moverse, Utilizacion de algún soporte de oxigeno',
      'Enfermedades': 'Obesidad (O)',
      'Beneficio Social': 'Garrafa Social',
      'Vacunas': 'Triple Viral',
      'Factores de Riesgo': 'Enfermedad Crónica / Hereditaria',
    },
  ),
  Formulario(
    idVisita: '002',
    idFamilia: '095',
    numSector: '066',
    numCasa: '015',
    nomTitular: 'Jose Hernández',
    direccion: 'Av. José de la Iglesia 1695',
    numTelefono: '3884701259',
    tipoCasa: 'Censada/ Ocupada (C/O)',
    tipoFamilia: 'Numerosa',
    coordinates: '-24.190140,-65.290114',
    resultados: {
      'Discapacidad': 'Perdida de sencibilidad en las manos o pies',
      'Enfermedades': 'Hipertensión Arterial(HTA)',
      'Beneficio Social': 'Apoyo alimentario',
      'Vacunas': 'Vacuna contra la Gripe',
      'Factores de Riesgo': 'Trastornos alimentarios',
    },
  ),
  Formulario(
    idVisita: '003',
    idFamilia: '037',
    numSector: '025',
    numCasa: '050',
    nomTitular: 'Elisa Roldán',
    direccion: 'Leandro Alem 572',
    numTelefono: '3884022117',
    tipoCasa: 'Censada/ Ocupada (C/O)',
    tipoFamilia: 'Nuclear',
    coordinates: '-24.190140,-65.290114',
    resultados: {
      'Discapacidad': 'Dificultad para moverse, Dificultad para ver',
      'Enfermedades': 'Diabetes (DBT)',
      'Beneficio Social': 'Garrafa Social, Comedores',
      'Vacunas': 'Triple Viral',
      'Factores de Riesgo': 'Consumo Problemático',
    },
  ),
  // Puedes agregar más instancias aquí
];
