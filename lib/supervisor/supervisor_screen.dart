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
        title: const Text(
          'SISFAM',
          style:
              TextStyle(fontSize: 20), // Ajusta el tamaño del texto del título
        ),
        backgroundColor: Colors.grey[200], // Gris claro
        actions: [
          Row(
            children: [
              const SizedBox(width: 8),
              const Text(
                'Bienvenido/a Supervisor/a',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14), // Ajusta el tamaño del texto
              ),
              IconButton(
                icon: const Icon(Icons.person,
                    size: 20), // Ajusta el tamaño del ícono
                onPressed: () => _showProfileDialog(context),
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
              width: 200,

              color: Colors.grey[100], // Gris claro para el menú
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                horizontal: 25,
                                vertical: 15), // Ajusta el padding
                            textStyle: const TextStyle(
                                fontSize: 18), // Tamaño del texto
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Radio de los bordes
                            ),
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
                  const SizedBox(height: 40),
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
                      'Control de Agentes sanitarios',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold), // De 22 a 18
                    ),
                    const SizedBox(height: 15),
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
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Tabla de resultados y tabla completa
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Centramos el contenido
                          children: [
                            // Tabla de resultados
                            if (filteredResults.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
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
                                            agentes: const [], // Tabla de resultados
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
                            const SizedBox(height: 10),
                            // Tabla completa
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.9, // Ajusta el ancho
                                    child: AgentsTable(
                                      textStyle: const TextStyle(fontSize: 18),
                                      agent: const [], // No mostrar resultados de búsqueda aquí
                                      agentes:
                                          agentes, // Mostrar todos los agentes
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Botones de filtro por fecha y descargar seleccionados
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Acción para descargar seleccionados
                            print('Descargar Seleccionados');
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue, // Color del texto
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14), // Ajusta el padding
                            textStyle: const TextStyle(
                                fontSize: 16), // Tamaño y peso del texto
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Radio de los bordes
                            ),
                          ),
                          child: const Text('Descargar Seleccionados'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => _selectDateRange(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(
                                190, 33, 149, 243), // Color del texto
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14), // Ajusta el padding
                            textStyle: const TextStyle(
                                fontSize: 16), // Tamaño y peso del texto
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Radio de los bordes
                            ),
                          ),
                          child: const Text('Filtrar por Fecha'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 43, // Ajusta la altura del footer
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
