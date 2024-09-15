import 'package:flutter/material.dart';
import 'agents_data.dart'; // Importar la lista de agentes

class AgentsTable extends StatelessWidget {
  final List<Agent> agent; // Para los resultados de búsqueda
  final List<Agent> agentes; // Para la lista completa de agentes
  final TextStyle textStyle;

  const AgentsTable({
    super.key,
    required this.textStyle,
    required this.agent,
    required this.agentes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Centra las columnas
      children: [
        // Mostrar tabla de resultados solo si `agent` no está vacío
        if (agent.isNotEmpty)
          Column(
            children: [
              const Text(
                'Resultados de la búsqueda',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width -
                        32, // Ajusta el ancho según el tamaño disponible
                  ),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Apellido')),
                      DataColumn(label: Text('Estado')),
                      DataColumn(label: Text('Fecha Último Acceso')),
                      DataColumn(label: Text('Informe Reciente')),
                    ],
                    rows: agent.map((agent) {
                      return DataRow(
                        cells: [
                          DataCell(Text(agent.id)),
                          DataCell(Text(agent.nombre)),
                          DataCell(Text(agent.apellido)),
                          DataCell(Text(agent.estadoDeTareas)),
                          DataCell(Text(agent.fechaUltimoAcceso)),
                          DataCell(Text(agent.informeReciente)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        // Mostrar tabla completa solo si `agentes` no está vacío
        if (agentes.isNotEmpty)
          Column(
            children: [
              const Text(
                'Lista Completa de Agentes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width -
                        32, // Ajusta el ancho según el tamaño disponible
                  ),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Apellido')),
                      DataColumn(label: Text('Estado')),
                      DataColumn(label: Text('Fecha Último Acceso')),
                      DataColumn(label: Text('Informe Reciente')),
                    ],
                    rows: agentes.map((agent) {
                      return DataRow(
                        cells: [
                          DataCell(Text(agent.id)),
                          DataCell(Text(agent.nombre)),
                          DataCell(Text(agent.apellido)),
                          DataCell(Text(agent.estadoDeTareas)),
                          DataCell(Text(agent.fechaUltimoAcceso)),
                          DataCell(Text(agent.informeReciente)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
