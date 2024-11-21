class CheckboxManager {
  Map<String, List<String>> categorias = {
    "Discapacidad": [
      "Dificultad para ver",
      "Dificultad para oir o hablar",
      "Dificultad para moverse",
      "Dificultad en el aprendizaje",
      "Perdida de sencibilidad en las manos o pies",
      "Utilizacion de algún soporte de oxigeno"
    ],
    "Enfermedades": [
      "Diabetes (DBT)",
      "Hipertensión Arterial(HTA)",
      "Obesidad (O)"
    ],
    "Beneficio Social": [
      "AUH",
      "Garrafa Social",
      "Apoyo alimentario",
      "Comedores",
      "Otros"
    ],
    "Vacunas": [
      "Hepatitis B",
      "Triple Viral",
      "Pentavalente",
      'Antineumocócica',
      'Vacuna contra la Gripe'
    ],
    "Factores de Riesgo": [
      "Antecedentes de Suicidio",
      "Violencia Familiar",
      "Consumo Problemático",
      "Enfermedad Crónica / Hereditaria",
      "Adolescente que no estudia ni trabaja",
      'Trastornos alimentarios',
      "Trabajo infantil"
    ]
  };

  Map<String, List<String>> seleccionadosPorCategoria = {
    "Beneficio Social": [],
    "Vacunas": [],
    "Factores de Riesgo": [],
    "Discapacidad": [],
    "Enfermedades": [],
  };

  Map<String, String> resultados = {
    "Beneficio Social": '',
    "Vacunas": '',
    "Factores de Riesgo": '',
    "Discapacidad": '',
    "Enfermedades": ''
  };

  void onCheckboxChanged(String categoria, String valor, bool isSelected) {
    if (isSelected) {
      seleccionadosPorCategoria[categoria]!.add(valor);
    } else {
      seleccionadosPorCategoria[categoria]!.remove(valor);
    }
  }

  // Método para actualizar los resultados basado en la selección de checkboxes
  /*
  void generarResultados() {
    // Lógica para generar los resultados y actualizar el Map
    // Por ejemplo:
    resultados["Beneficio Social"] = obtenerBeneficioSeleccionado();
    resultados["Vacunas"] = obtenerVacunasSeleccionadas();
    resultados["Factores de Riesgo"] = obtenerFactoresSeleccionados();
    resultados["Discapacidad"] = obtenerDiscapacidadSeleccionada();
    resultados["Enfermedades"] = obtenerEnfermedadesSeleccionadas();
  }

  */

  void generarResultados() {
    seleccionadosPorCategoria.forEach((key, value) {
      resultados[key] = value.isNotEmpty
          ? value.join(', ')
          : 'Ninguno seleccionado'; // Genera el texto para la categoría.
    });
  }
}
