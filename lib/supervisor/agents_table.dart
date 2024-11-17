import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/user.dart'; // Importar el archivo de User

class AgentsTable extends StatefulWidget {
  final List<User> agent; // Para los resultados de búsqueda
  final List<User> agentes; // Para la lista completa de agentes
  final TextStyle textStyle;
  final ValueChanged<User>? onAgentSelected; // Callback para la selección de un usuario

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
  Set<User> selectedUsers = {}; // Conjunto de usuarios seleccionados

  void _onAgentSelected(User user, bool selected) {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
      // Llamar al callback si se proporciona
      if (widget.onAgentSelected != null) {
        widget.onAgentSelected!(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 800; // Para pantallas grandes

    // Filtrar solo los agentes sanitarios
    final agentsSanitarios = (widget.agent.isNotEmpty ? widget.agent : widget.agentes)
        .where((user) => user.rol == 'Agente Sanitario')
        .toList();

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 16.0 : 8.0, // Reducir márgenes en pantallas pequeñas
          vertical: 8.0, // Reducir espacio vertical
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (agentsSanitarios.isNotEmpty) // Mostrar solo si hay agentes sanitarios
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Lista de Agentes Sanitarios',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 14, // Reducir el tamaño del título
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), // Reducir espacio entre el título y la tabla
                  Container(
                    width: double.infinity, // Permitir que el contenedor ocupe todo el ancho disponible
                    height: screenHeight * 0.65, // Ajustar la altura de la tabla
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
                          minWidth: screenWidth * 0.8, // Reducir el ancho mínimo
                        ),
                        child: DataTable(
                          columnSpacing: 12.0, // Reducir el espacio entre columnas
                          headingRowHeight: isLargeScreen ? 50.0 : 40.0, // Reducir altura de los encabezados
                          dataRowHeight: 40.0, // Reducir altura de las filas
                          columns: [
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
                                  Checkbox(
                                    value: selectedUsers.contains(user),
                                    onChanged: (bool? value) {
                                      _onAgentSelected(user, value ?? false);
                                    },
                                  ),
                                ),
                                DataCell(Text(
                                  user.nombre,
                                  style: widget.textStyle.copyWith(fontSize: 14), // Reducir tamaño del texto
                                )),
                                DataCell(Text(
                                  user.apellido,
                                  style: widget.textStyle.copyWith(fontSize: 14),
                                )),
                                DataCell(Text(
                                  user.estado,
                                  style: widget.textStyle.copyWith(fontSize: 14),
                                )),
                                DataCell(Text(
                                  user.fechaUltimoAcceso.toString(),
                                  style: widget.textStyle.copyWith(fontSize: 14),
                                )),
                                DataCell(Text(
                                  user.informeReciente,
                                  style: widget.textStyle.copyWith(fontSize: 14),
                                )),
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
