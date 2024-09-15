import 'package:flutter/material.dart';
import 'profile_dialogs.dart'; // Información de profile
import 'agents_data.dart'; // Para buscar datos de agentes
import 'agents_table.dart'; // Para el widget AgentsTable
import 'form_buttons.dart'; // Para el widget FormButtons
import 'notifications_panel.dart'; // Panel de notificaciones
import 'sidebar_menu.dart'; // Menú lateral

class SupervisorDashboard extends StatelessWidget {
  SupervisorDashboard({super.key});

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SISFAM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showProfileDialog(context),
          ),
        ],
      ),
      body: Row(
        children: [
          // Panel lateral izquierdo
          Container(
            width: 250,
            color: Colors.grey[200],
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

                // Menú lateral
                const Expanded(child: SidebarMenu()),

                // Ajustar el espaciado para el panel de notificaciones
                const SizedBox(height: 10), // Añadir más espacio arriba

                // Panel de notificaciones (ahora con más espacio y relleno)
                Container(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  color: Colors.white,
                  child: const SizedBox(
                    height: 400, // Ajustado para que tenga más espacio
                    child:
                        NotificationsPanel(), // Reemplaza con NotificationsPanel
                  ),
                ),

                // Añadir más espaciado después del panel de notificaciones
                const SizedBox(height: 40),

                const FormButtons(), // Botones o elementos adicionales
              ],
            ),
          ),

          // Panel de control principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Encabezado del área principal
                  const Text(
                    'Bienvenido/a Supervisor/a',
                    style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Control de Agentes sanitarios',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 50),

                  // Formulario de búsqueda centrado
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Minimizar espacio
                      children: [
                        const Text(
                          'Buscar',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: nombreController,
                            decoration: const InputDecoration(
                              hintText: 'Nombre',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: apellidoController,
                            decoration: const InputDecoration(
                              hintText: 'Apellido',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(8.0),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // Implementación del botón de búsqueda
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Centrar la tabla y aumentar tamaño de la letra
                  const Expanded(
                    child: Center(
                      child: AgentsTable(
                        textStyle: TextStyle(
                            fontSize: 18), // Aumenta el tamaño de la letra
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Descargar seleccionados'),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Página web', style: TextStyle(fontSize: 16)),
              Text('Acerca de', style: TextStyle(fontSize: 16)),
              Text('Soporte', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
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

  List<Agent> buscarAgentePorNombreApellido(String nombre, String apellido) {
    return agentes.where((agent) {
      return agent.nombre.toLowerCase() == nombre.toLowerCase() &&
          agent.apellido.toLowerCase() == apellido.toLowerCase();
    }).toList();
  }

  void mostrarResultadosBusqueda(
      BuildContext context, String nombre, String apellido) {
    List<Agent> resultados = buscarAgentePorNombreApellido(nombre, apellido);

    if (resultados.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sin resultados'),
            content: const Text(
                'No se encontraron tareas asignadas para el agente sanitario.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Resultados de búsqueda'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: resultados.map((agent) {
                return ListTile(
                  title: Text('${agent.nombre} ${agent.apellido}'),
                  subtitle: Text('Estado de tareas: ${agent.estadoDeTareas}'),
                );
              }).toList(),
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
  }
}
