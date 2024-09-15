import 'package:flutter/material.dart';

class AgentsTable extends StatelessWidget {
  final TextStyle? textStyle; // Estilo de texto opcional

  const AgentsTable({Key? key, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Nombre')),
        DataColumn(label: Text('Apellido')),
        DataColumn(label: Text('Estado de Tarea')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('Adrián', style: textStyle)),
          DataCell(Text('Solis', style: textStyle)),
          DataCell(Text('Vencida', style: textStyle)),
        ]),
        DataRow(cells: [
          DataCell(Text('Andrés', style: textStyle)),
          DataCell(Text('Fariña', style: textStyle)),
          DataCell(Text('Por vencer', style: textStyle)),
        ]),
        DataRow(cells: [
          DataCell(Text('Lucía', style: textStyle)),
          DataCell(Text('Gómez', style: textStyle)),
          DataCell(Text('Completada', style: textStyle)),
        ]),
      ],
    );
  }
}
