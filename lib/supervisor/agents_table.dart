import 'package:flutter/material.dart';

class AgentsTable extends StatelessWidget {
  const AgentsTable({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para la tabla
    final List<Map<String, String>> agents = [
      {'name': 'Adrián Solís', 'status': 'Vencida'},
      {'name': 'Andrés Fariña', 'status': 'Por vencer'},
      {'name': 'Lucía Gómez', 'status': 'Completada'},
    ];

    return DataTable(
      columns: const [
        DataColumn(label: Text('Nombre')),
        DataColumn(label: Text('Estado de Tarea')),
      ],
      rows: agents.map((agent) {
        return DataRow(cells: [
          DataCell(Text(agent['name']!)),
          DataCell(Text(agent['status']!)),
        ]);
      }).toList(),
    );
  }
}
