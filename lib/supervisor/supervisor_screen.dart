// lib/screens/supervisor_dashboard.dart
import 'package:flutter/material.dart';
import '../models/profile_dialogs.dart';
import '../models/user.dart';
import 'agents_table.dart';
import 'notifications_panel.dart';
import 'sidebar_menu.dart';
import 'search_form.dart';
import '../models/footer.dart';
import 'services/user_service.dart';
import 'services/pdf_service.dart';

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({super.key});

  @override
  SupervisorDashboardState createState() => SupervisorDashboardState();
}

class SupervisorDashboardState extends State<SupervisorDashboard> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserService _userService = UserService();
  final PdfService _pdfService = PdfService();
  
  DateTime? startDate;
  DateTime? endDate;
  List<User> searchResults = [];
  List<User> filteredResults = [];
  bool _isSidebarExpanded = false; // Menú cerrado por defecto

  @override
  void initState() {
    super.initState();
    _setupControllers();
  }

  void _setupControllers() {
    nombreController.addListener(_performSearch);
    apellidoController.addListener(_performSearch);
  }

  void _performSearch() {
    setState(() {
      filteredResults = _userService.searchUsers(
        searchResults,
        nombreController.text,
        apellidoController.text,
      );
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      drawer: const NotificationsScreen(userId: 'supervisorId'),
      body: _buildBody(context),
      bottomNavigationBar: _buildFooter(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: _toggleSidebar, // Toggle sidebar
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
              'Bienvenido Supervisor',
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

  Widget _buildBody(BuildContext context) {

    return Container(
      color: Colors.grey[100],
      child: Stack(
        children: [
          Row(
            children: [
              if (_isSidebarExpanded) _buildSidebar(), // Solo si el menú está expandido
              Expanded(child: _buildMainContent(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isSidebarExpanded ? 220 : 0, // Mostrar barra lateral si está expandida
      color: Colors.blueGrey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: SidebarMenu()), // Menú siempre visible
          _buildNotificationsButton(), // Botón de notificaciones siempre visible
        ],
      ),
    );
  }

  Widget _buildNotificationsButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        child: const Text('Ver Notificaciones', style: TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildSearchSection(),
          const SizedBox(height: 10),
          _buildAgentsTable(context),
          const SizedBox(height: 10),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Control de Agentes Sanitarios',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(
          child: SearchForm(
            nombreController: nombreController,
            apellidoController: apellidoController,
            onSearch: _performSearch,
          ),
        ),
      ],
    );
  }

  Widget _buildAgentsTable(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<User>>(
        stream: _userService.getUsersStream(), // Usar un stream en lugar de una carga estática
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay agentes sanitarios disponibles.'));
          } else {
            searchResults = snapshot.data!;
            filteredResults = _userService.filterAgenteSanitario(searchResults);
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: AgentsTable(
                          textStyle: const TextStyle(fontSize: 14),
                          agent: filteredResults,
                          agentes: const [],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Usar Expanded para que el botón se ajuste adecuadamente
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0), // Espaciado para que no se pegue a los bordes
          child: ElevatedButton(
            onPressed: () => _pdfService.downloadSelectedTasks(filteredResults),
            style: _actionButtonStyle(Colors.green),
            child: const Text('Descargar PDF de Tareas'),
          ),
        ),
      ),
    ],
  );
}


  Widget _buildFooter() {
    return Container(
      height: 50,
      color: Colors.grey[300],
      child: const Footer(),
    );
  }

  ButtonStyle _actionButtonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      textStyle: const TextStyle(fontSize: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const ProfileDialog(),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    super.dispose();
  }
}
