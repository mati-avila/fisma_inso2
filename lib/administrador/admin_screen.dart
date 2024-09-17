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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administrador'),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.lightBlue,
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
                    icon: Icon(Icons.search, color: Colors.lightBlue),
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
            child: _selectedIndex == 0
                ? UserList(userType: 'Agente Sanitario', searchQuery: _searchQuery)
                : UserList(userType: 'Supervisor', searchQuery: _searchQuery),
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
                width: 200, // Hacemos el botón más ancho
                child: ElevatedButton(
                  onPressed: _showAddUserDialog,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white), // Cambiamos el color del icono a blanco
                      SizedBox(width: 8),
                      Text(
                        'Agregar Usuario',
                        style: TextStyle(color: Colors.white), // Cambiamos el color del texto a blanco
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 105, 200, 245), // Mantenemos el color de fondo actual
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
            selectedItemColor: Colors.lightBlue,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}