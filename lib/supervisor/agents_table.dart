import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/user.dart';


// ignore: must_be_immutable
class AgentsTable extends StatefulWidget {
  List<User> agent;
  final List<User> agentes;
  final TextStyle textStyle;
  final ValueChanged<User>? onAgentSelected;

  AgentsTable({
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
  Set<User> selectedAgents = {};

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de ${user.nombre} ${user.apellido}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre: ${user.nombre}'),
                Text('Apellido: ${user.apellido}'),
                Text('Estado: ${user.estado}'),
                Text('Fecha Último Acceso: ${user.fechaUltimoAcceso}'),
                Text('Informe Reciente: ${user.informeReciente}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSelection(User user, bool? selected) {
    setState(() {
      if (selected == true) {
        selectedAgents.add(user);
      } else {
        selectedAgents.remove(user);
      }
    });
    if (widget.onAgentSelected != null) {
      widget.onAgentSelected!(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 800;

    final agentsSanitarios = (widget.agent.isNotEmpty ? widget.agent : widget.agentes)
        .where((user) => user.rol == 'Agente Sanitario')
        .toList();

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 16.0 : 8.0,
          vertical: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (agentsSanitarios.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Lista de Agentes Sanitarios',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.65,
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
                          minWidth: screenWidth * 0.8,
                        ),
                        child: DataTable(
                          columnSpacing: 12.0,
                          headingRowHeight: isLargeScreen ? 50.0 : 40.0,
                          dataRowHeight: 40.0,
                          columns: const [
                            DataColumn(label: Text('Seleccionar')),
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Apellido')),
                            DataColumn(label: Text('Estado')),
                            DataColumn(label: Text('Fecha Último Acceso')),
                            DataColumn(label: Text('Informe Reciente')),
                          ],
                          rows: agentsSanitarios.map((user) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Center(
                                    child: Checkbox(
                                      value: selectedAgents.contains(user),
                                      onChanged: (bool? value) {
                                        _toggleSelection(user, value);
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    user.nombre,
                                    style: widget.textStyle.copyWith(fontSize: 14),
                                  ),
                                  onTap: () => _showUserDetails(user),
                                ),
                                DataCell(
                                  Text(
                                    user.apellido,
                                    style: widget.textStyle.copyWith(fontSize: 14),
                                  ),
                                  onTap: () => _showUserDetails(user),
                                ),
                                DataCell(
                                  Text(
                                    user.estado,
                                    style: widget.textStyle.copyWith(fontSize: 14),
                                  ),
                                  onTap: () => _showUserDetails(user),
                                ),
                                DataCell(
                                  Text(
                                    user.fechaUltimoAcceso.toString(),
                                    style: widget.textStyle.copyWith(fontSize: 14),
                                  ),
                                  onTap: () => _showUserDetails(user),
                                ),
                                DataCell(
                                  Text(
                                    user.informeReciente,
                                    style: widget.textStyle.copyWith(fontSize: 14),
                                  ),
                                  onTap: () => _showUserDetails(user),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (agentsSanitarios.isEmpty)
              Text(
                'No hay agentes sanitarios disponibles.',
                style: widget.textStyle.copyWith(fontSize: 14, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}