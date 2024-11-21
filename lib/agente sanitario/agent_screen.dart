import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_options.dart';
import 'package:fisma_inso2/models/profile_dialogs.dart';
import 'sidebar_menu.dart';
import 'map_view.dart';
import 'form_buttons.dart';
import 'filtered_list.dart';
import 'package:fisma_inso2/models/footer.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  String userName = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Añadir la clave del Scaffold

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Agente';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Scaffold(
      key: _scaffoldKey, // Asignar la clave al Scaffold
      appBar: _buildAppBar(context),
      drawer: isMobile ? _buildDrawer() : null, // Usar el drawer solo en móvil
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      bottomNavigationBar: const Footer(),
    );
  }

  // AppBar modificado para dispositivos móviles
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          // Abrir el menú lateral en dispositivos móviles
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: const Text(
        'SISFAM',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blueAccent,
      actions: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: Text(
              'Bienvenido Agente',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person, size: 26),
          onPressed: () => _showProfileDialog(context),
        ),
      ],
    );
  }

  // Crear el Drawer para dispositivos móviles
  Widget _buildDrawer() {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SidebarMenu(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '¡Bienvenido, $userName!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 47, 83, 102),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Botones de formulario compactos
            const FormButtons(),
            const SizedBox(height: 16),
            
            // Mapa con altura fija para móvil
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const MapView(),
                  ),
                  // Opciones del mapa en un menú desplegable para móvil
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        // Mostrar opciones del mapa en un modal bottom sheet
                        _showMapOptionsBottomSheet(context);
                      },
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Lista filtrada
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: FilteredList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar para desktop
        Container(
          width: 300,
          color: Colors.grey[200],
          child: const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: SidebarMenu(),
          ),
        ),
        // Contenido principal
        Expanded(
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Text(
                          '¡Bienvenido, $userName!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 47, 83, 102),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: const MapView(),
                                ),
                              ),
                              const Positioned(
                                top: 10,
                                left: 10,
                                right: 10,
                                child: MapOptions(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const FormButtons(),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FilteredList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleSidebar() {
    // Lógica para abrir/cerrar el sidebar
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ProfileDialog();
      },
    );
  }

  void _showMapOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Opciones del Mapa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const MapOptions(),
            ],
          ),
        );
      },
    );
  }
}
