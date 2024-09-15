import 'package:flutter/material.dart';
import 'profile_dialogs.dart'; // Información de profile
import 'agents_data.dart'; // Para buscar datos de agentes
import 'agents_table.dart'; // Para el widget AgentsTable
import 'notifications_panel.dart'; // Panel de notificaciones
import 'sidebar_menu.dart'; // Menú lateral
import 'search_form.dart'; // Componente de búsqueda
import 'footer.dart'; // Importar el widget Footer

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({super.key});

  @override
  SupervisorDashboardState createState() => SupervisorDashboardState();
}

class SupervisorDashboardState extends State<SupervisorDashboard> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  List<Agent> searchResults =
      []; // Lista para almacenar los resultados de la búsqueda
  List<Agent> filteredResults =
      []; // Lista para almacenar los resultados filtrados por fecha
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('SISFAM'),
        backgroundColor: Colors.grey[200], // Gris claro
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => _showProfileDialog(context),
              ),
              const SizedBox(width: 8),
              const Text(
                'Perfil',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      drawer: const Drawer(
        child:
            NotificationsPanel(), // Coloca el panel de notificaciones en el Drawer
      ),
      body: Container(
        color: Colors.white, // Fondo blanco
        child: Row(
          children: [
            Container(
              width: 300,
              color: Colors.grey[100], // Gris claro para el menú
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Supervisor',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Expanded(child: SidebarMenu()),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top:
                                30.0), // Ajusta el padding para centrar más arriba
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor:
                                Colors.grey[200], // Color del texto negro
                            padding: const EdgeInsets.symmetric(
                                horizontal: 38,
                                vertical: 20), // Ajusta el padding
                            textStyle: const TextStyle(
                                fontSize: 18), // Tamaño del texto
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState
                                ?.openDrawer(); // Abre el Drawer
                          },
                          child: const Text('Ver Notificaciones'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Bienvenido/a Supervisor/a',
                      style:
                          TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Control de Agentes sanitarios',
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 40),
                    // Filtros de búsqueda y fecha
                    Row(
                      children: [
                        Expanded(
                          child: SearchForm(
                            nombreController: nombreController,
                            apellidoController: apellidoController,
                            onSearch: _performSearch,
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => _selectDateRange(context),
                          child: const Text('Filtrar por Fecha'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Tabla de resultados y tabla completa
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            // Tabla de resultados
                            if (filteredResults.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Center(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1, // Ajusta el ancho
                                          child: AgentsTable(
                                            textStyle:
                                                const TextStyle(fontSize: 18),
                                            agent:
                                                filteredResults, // Mostrar resultados filtrados por fecha
                                            agentes: [], // Tabla de resultados
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Botón de limpiar búsqueda
                            if (filteredResults.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      filteredResults
                                          .clear(); // Limpiar resultados filtrados
                                    });
                                  },
                                  child: const Text('Limpiar búsqueda'),
                                ),
                              ),
                            const SizedBox(height: 20),
                            // Tabla completa
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Stack(
                                children: [
                                  Center(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9, // Ajusta el ancho
                                        child: AgentsTable(
                                          textStyle:
                                              const TextStyle(fontSize: 18),
                                          agent: [], // No mostrar resultados de búsqueda aquí
                                          agentes:
                                              agentes, // Mostrar todos los agentes
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    right: 16,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Acción para descargar seleccionados
                                        print('Descargar Seleccionados');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Colors.blue, // Color del texto
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 16), // Ajusta el padding
                                        textStyle: const TextStyle(
                                            fontSize:
                                                18), // Tamaño y peso del texto
                                      ),
                                      child:
                                          const Text('Descargar Seleccionados'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[200], // Gris claro
        child: const Footer(),
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ProfileDialog();
      },
    );
  }

  void _performSearch() {
    setState(() {
      searchResults = buscarAgentePorNombreApellido(
        nombreController.text,
        apellidoController.text,
      );
      _applyDateFilter(); // Aplica el filtro de fechas después de la búsqueda
    });
  }

  void _selectDateRange(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? start = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (start != null) {
      DateTime? end = await showDatePicker(
        context: context,
        initialDate: endDate ?? start,
        firstDate: start,
        lastDate: DateTime(2100),
      );
      if (end != null) {
        setState(() {
          startDate = start;
          endDate = end;
          _applyDateFilter(); // Aplicar filtro de fechas
        });
      }
    }
  }

  void _applyDateFilter() {
    if (startDate != null && endDate != null) {
      filteredResults = searchResults.where((agent) {
        DateTime taskDate = DateTime.parse(agent.fechaUltimoAcceso);
        return taskDate.isAfter(startDate!) && taskDate.isBefore(endDate!);
      }).toList();
    } else {
      filteredResults = searchResults;
    }
  }

  List<Agent> buscarAgentePorNombreApellido(String nombre, String apellido) {
    return agentes.where((agent) {
      return agent.nombre.toLowerCase().contains(nombre.toLowerCase()) &&
          agent.apellido.toLowerCase().contains(apellido.toLowerCase());
    }).toList();
  }
}
