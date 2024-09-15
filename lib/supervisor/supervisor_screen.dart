import 'package:flutter/material.dart';
import 'profile_dialogs.dart'; // Información de profile
import 'agents_data.dart'; // Para buscar datos de agentes
import 'agents_table.dart'; // Para el widget AgentsTable
import 'form_buttons.dart'; // Para el widget FormButtons
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
  List<Agent> searchResults =
      []; // Lista para almacenar los resultados de la búsqueda

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SISFAM'),
        backgroundColor: Colors.grey[200], // Gris claro
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showProfileDialog(context),
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // Fondo blanco
        child: Row(
          children: [
            Container(
              width: 300,
              color: Colors.grey[200], // Gris claro para el menú
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
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
                    color: Colors.white,
                    child: const SizedBox(
                      height: 500,
                      child: NotificationsPanel(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const FormButtons(),
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
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 50),
                    // Pasa la función de búsqueda al SearchForm
                    Center(
                      child: SearchForm(
                        nombreController: nombreController,
                        apellidoController: apellidoController,
                        onSearch: _performSearch,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tabla de resultados y tabla completa
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            // Tabla de resultados
                            if (searchResults.isNotEmpty)
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
                                              0.9, // Ajusta el ancho
                                          child: AgentsTable(
                                            textStyle:
                                                const TextStyle(fontSize: 18),
                                            agent: searchResults,
                                            agentes: [], // Tabla de resultados
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Botón de limpiar búsqueda
                            if (searchResults.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      searchResults
                                          .clear(); // Limpiar resultados de búsqueda
                                    });
                                  },
                                  child: const Text('Limpiar búsqueda'),
                                ),
                              ),
                            const SizedBox(height: 20),
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
                                      agent: [], // No mostrar resultados de búsqueda aquí
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
    });
  }

  List<Agent> buscarAgentePorNombreApellido(String nombre, String apellido) {
    return agentes.where((agent) {
      return agent.nombre.toLowerCase().contains(nombre.toLowerCase()) &&
          agent.apellido.toLowerCase().contains(apellido.toLowerCase());
    }).toList();
  }
}
