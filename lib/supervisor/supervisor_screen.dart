import 'package:flutter/material.dart';
import 'profile_dialogs.dart';
import 'package:fisma_inso2/models/user.dart'; // Importar la clase User
import 'agents_table.dart';
import 'notifications_panel.dart';
import 'sidebar_menu.dart';
import 'search_form.dart';
import 'footer.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  List<User> searchResults = [];
  List<User> filteredResults = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Obtener usuarios desde Firebase
  Future<List<User>> _getUsers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
      List<User> users = snapshot.docs.map((doc) {
        return User.fromFirestore(doc); // Crear objetos User desde Firestore
      }).toList();
      return users;
    } catch (e) {
      print("Error obteniendo usuarios: $e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsers().then((users) {
      setState(() {
        searchResults = users;
        filteredResults = searchResults.where((user) => user.rol == 'Agente Sanitario').toList();
      });
    });

    // Actualizar los resultados al escribir
    nombreController.addListener(_performSearch);
    apellidoController.addListener(_performSearch);
  }

  // Función de búsqueda
  void _performSearch() {
    setState(() {
      // Si los campos están vacíos, mostramos todos los "Agente Sanitario"
      if (nombreController.text.isEmpty && apellidoController.text.isEmpty) {
        filteredResults = searchResults.where((user) => user.rol == 'Agente Sanitario').toList();
      } else {
        // De lo contrario, filtramos según el nombre y apellido
        filteredResults = searchResults.where((user) {
          return user.nombre.toLowerCase().contains(nombreController.text.toLowerCase()) &&
                 user.apellido.toLowerCase().contains(apellidoController.text.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
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
      ),
      drawer: NotificationsPanel(userId: 'supervisorId'), // Aquí pasas el ID del supervisor
      body: Container(
        color: Colors.grey[100],
        child: Row(
          children: [
            Container(
              width: 220,
              color: Colors.blueGrey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: SidebarMenu()),
                  Padding(
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
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: const Text('Ver Notificaciones', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Control de Agentes Sanitarios',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (filteredResults.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
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
                                            agentes: const [], // Este puede cambiar si es necesario
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (filteredResults.isEmpty)
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.95,
                                  child: AgentsTable(
                                    textStyle: const TextStyle(fontSize: 14),
                                    agent: const [],
                                    agentes: searchResults,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _downloadSelectedTasks,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Descargar PDF de Tareas'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _selectDateRange(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            textStyle: const TextStyle(fontSize: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
        height: 50,
        color: Colors.grey[300],
        child: const Footer(),
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProfileDialog();
      },
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? selectedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blueAccent,
            scaffoldBackgroundColor: Colors.blueAccent,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (selectedDateRange != null) {
      setState(() {
        startDate = selectedDateRange.start;
        endDate = selectedDateRange.end;
      });
    }
  }

  // Método para generar el PDF
  Future<void> _downloadSelectedTasks() async {
  final pdf = pw.Document();

  // Agregar una página al documento
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Tareas de Agentes Sanitarios', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            // Iterar sobre los resultados filtrados y agregar las tareas
            ...filteredResults.map((user) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Usuario: ${user.nombre} ${user.apellido}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Tareas:'),
                  // Aquí agregamos las tareas relacionadas a cada usuario
                  ...user.tareas.map((task) {
                    return pw.Text('• ${task.description}', style: pw.TextStyle(fontSize: 14));
                  }).toList(),
                  pw.SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        );
      },
    ),
  );

  // Guardar el documento PDF y abrir para impresión
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

}
