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
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centra el contenido
          children: [
            if (widget.agent.isNotEmpty || widget.agentes.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Lista de Agentes Sanitarios',
                    style: TextStyle(
                      fontSize: screenWidth > 600
                          ? 18
                          : 16, // Ajustar tamaño del título
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              screenWidth * 0.9, // Ajustar tamaño de la tabla
                        ),
                        child: DataTable(
                          columnSpacing: 16.0,
                          headingRowHeight: 60.0,
                          dataRowMaxHeight: 60.0,
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
                            return DataRow(
                              cells: [
                                DataCell(
                                  Checkbox(
                                    value: selectedAgents.contains(agent),
                                    onChanged: (bool? value) {
                                      _onAgentSelected(agent, value ?? false);
                                    },
                                  ),
                                ),
                                DataCell(Text(agent.id,
                                    style: widget.textStyle
                                        .copyWith(fontSize: 14))),
                                DataCell(Text(agent.nombre,
                                    style: widget.textStyle
                                        .copyWith(fontSize: 14))),
                                DataCell(Text(agent.apellido,
                                    style: widget.textStyle
                                        .copyWith(fontSize: 14))),
                                DataCell(Text(agent.estadoDeTareas,
                                    style: widget.textStyle
                                        .copyWith(fontSize: 14))),
                                DataCell(Text(agent.fechaUltimoAcceso,
                                    style: widget.textStyle
                                        .copyWith(fontSize: 14))),
                                DataCell(Text(agent.informeReciente,
                                    style: widget.textStyle
                                        .copyWith(fontSize: 14))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
