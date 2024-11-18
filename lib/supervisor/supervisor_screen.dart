// lib/screens/supervisor_dashboard.dart
import 'package:flutter/material.dart';
import '../models/profile_dialogs.dart';
import '../models/user.dart';
import 'agents_table.dart';
import 'notifications_panel.dart';
import 'sidebar_menu.dart';
import 'search_form.dart';
import 'footer.dart';
import 'services/user_service.dart';
import 'services/pdf_service.dart';
import 'date_range_selector.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupControllers();
  }

  void _initializeData() async {
    final users = await _userService.getUsers();
    setState(() {
      searchResults = users;
      filteredResults = _userService.filterAgenteSanitario(users);
    });
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
              'Bienvenido/a Supervisor/a',
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
      child: Row(
        children: [
          _buildSidebar(),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
  return Container(
    width: 220,
    color: Colors.blueGrey[50],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: SidebarMenu()),
        _buildNotificationsButton(),
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
    return Expanded(
      child: Padding(
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
      child: SingleChildScrollView(
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
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _pdfService.downloadSelectedTasks(filteredResults),
          style: _actionButtonStyle(Colors.green),
          child: const Text('Descargar PDF de Tareas'),
        ),
        const SizedBox(width: 10),
        DateRangeSelector(
          onDateRangeSelected: (start, end) {
            setState(() {
              startDate = start;
              endDate = end;
            });
          },
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
      builder: (BuildContext context) => ProfileDialog(),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    super.dispose();
  }
}