import 'package:flutter/material.dart';
import 'add_user_form.dart';
import 'user_list.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _searchQuery = '';
  int _selectedIndex = 0;

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: AddUserForm(),
          ),
        );
      },
    );
  }

  // Método para cambiar entre agentes sanitarios y supervisores
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _searchQuery = ''; // Limpiar la búsqueda al cambiar de vista
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administrador'),
        backgroundColor: Color.fromARGB(255, 38, 147, 236), // Fondo azul
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[300], // Color de fondo gris claro
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar usuarios...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.blue[400]), // Icono azul claro
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: UserList(
              userType: _selectedIndex == 0 ? 'Agente Sanitario' : 'Supervisor',
              searchQuery: _searchQuery,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _showAddUserDialog,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Agregar Usuario',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700], // Azul más oscuro para el botón
                    padding: EdgeInsets.symmetric(vertical: 25),
                  ),
                ),
              ),
            ),
          ),
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.health_and_safety),
                label: 'Agentes Sanitarios',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.supervisor_account),
                label: 'Supervisores',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue[700], // Ítem seleccionado azul oscuro
            unselectedItemColor: Colors.grey[600], // Ítem no seleccionado en gris
            backgroundColor: Color.fromARGB(255, 200, 202, 202), // Fondo gris claro
            onTap: _onItemTapped, // Cambia de vista al tocar los botones
          ),
        ],
      ),
    );
  }
}
