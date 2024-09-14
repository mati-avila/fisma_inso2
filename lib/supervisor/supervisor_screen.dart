import 'package:flutter/material.dart';

class SupervisorDashboard extends StatelessWidget {
  const SupervisorDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SISFAM'),
            Row(
              children: [
                Text('Buscar'),
                Icon(Icons.search),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person),
                ),
              ],
            ),
          ],
        ),
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
                  child: Text('Supervisor',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                const ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text('Asignación de tareas'),
                ),
                const ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configuración'),
                ),
                const ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Cerrar sesión'),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Notificaciones',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text('Tarea vencida'),
                        subtitle:
                            const Text('Se informa que la tarea X ha vencido.'),
                        trailing: TextButton(
                            onPressed: () {}, child: const Text('Abrir')),
                      ),
                      ListTile(
                        title: const Text('Tarea pendiente'),
                        subtitle: const Text(
                            'Se informa que la tarea Y está próxima a vencerse.'),
                        trailing: TextButton(
                            onPressed: () {}, child: const Text('Aceptar')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Panel de control principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bienvenido/a Supervisor/a',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Control de Agentes sanitarios',
                      style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  // Tabla de datos
                  Expanded(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Nombre y Apellido')),
                        DataColumn(label: Text('Estado de tareas')),
                        DataColumn(label: Text('Fecha de último acceso')),
                        DataColumn(label: Text('Informes recientes')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Checkbox(
                              value: false, onChanged: (bool? value) {})),
                          const DataCell(Text('Adrian Solis')),
                          const DataCell(Text('Activo')),
                          const DataCell(Text('Mayo 24, 2024')),
                          DataCell(TextButton(
                              onPressed: () {},
                              child: const Text('Descargar Informe'))),
                        ]),
                        DataRow(cells: [
                          DataCell(Checkbox(
                              value: false, onChanged: (bool? value) {})),
                          const DataCell(Text('Andrea Farfan')),
                          const DataCell(Text('En curso')),
                          const DataCell(Text('Mayo 23, 2024')),
                          DataCell(TextButton(
                              onPressed: () {},
                              child: const Text('Descargar Informe'))),
                        ]),
                        // Agrega más filas según los datos
                      ],
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
}
