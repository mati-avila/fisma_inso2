import 'package:flutter/material.dart';
import 'agents_data.dart'; // Importar la lista de agentes

class AgentsTable extends StatefulWidget {
  final List<Agent> agent; // Para los resultados de búsqueda
  final List<Agent> agentes; // Para la lista completa de agentes
  final TextStyle textStyle;
  final ValueChanged<Agent>?
      onAgentSelected; // Callback para la selección de un agente

  const AgentsTable({
    super.key,
    required this.textStyle,
    required this.agent,
    required this.agentes,
    this.onAgentSelected,
  });

  @override
  _AgentsTableState createState() => _AgentsTableState();
}

class _AgentsTableState extends State<AgentsTable> {
  Set<Agent> selectedAgents = {}; // Conjunto de agentes seleccionados

  void _onAgentSelected(Agent agent, bool selected) {
    setState(() {
      if (selected) {
        selectedAgents.add(agent);
      } else {
        selectedAgents.remove(agent);
      }
      // Llamar al callback si se proporciona
      if (widget.onAgentSelected != null) {
        widget.onAgentSelected!(agent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.agent.isNotEmpty || widget.agentes.isNotEmpty)
            Column(
              children: [
                const Text(
                  'Lista de Agentes Sanitarios',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 32,
                    ),
                    child: DataTable(
                      columnSpacing: 8.0,
                      headingRowHeight: 50.0,
                      dataRowHeight: 50.0,
                      columns: const [
                        DataColumn(label: Text('Seleccionar')),
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Apellido')),
                        DataColumn(label: Text('Estado')),
                        DataColumn(label: Text('Fecha Último Acceso')),
                        DataColumn(label: Text('Informe Reciente')),
                      ],
                      rows: (widget.agent.isNotEmpty
                              ? widget.agent
                              : widget.agentes)
                          .map((agent) {
                        final isSelected = selectedAgents.contains(agent);
                        return DataRow(
                          cells: [
                            DataCell(
                              Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  _onAgentSelected(agent, value ?? false);
                                },
                              ),
                            ),
                            DataCell(Text(agent.id,
                                style:
                                    widget.textStyle.copyWith(fontSize: 14))),
                            DataCell(Text(agent.nombre,
                                style:
                                    widget.textStyle.copyWith(fontSize: 14))),
                            DataCell(Text(agent.apellido,
                                style:
                                    widget.textStyle.copyWith(fontSize: 14))),
                            DataCell(Text(agent.estadoDeTareas,
                                style:
                                    widget.textStyle.copyWith(fontSize: 14))),
                            DataCell(Text(agent.fechaUltimoAcceso,
                                style:
                                    widget.textStyle.copyWith(fontSize: 14))),
                            DataCell(Text(agent.informeReciente,
                                style:
                                    widget.textStyle.copyWith(fontSize: 14))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
        ],
      ),
    );
  }
}
