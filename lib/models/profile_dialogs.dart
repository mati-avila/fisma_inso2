import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Necesitarás este paquete para acceder a SharedPreferences
import 'package:fisma_inso2/loggin.dart'; // Asegúrate de importar la pantalla de inicio de sesión

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserInfo(), // Recupera la información del usuario
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene la información
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Obtén los datos del usuario del snapshot
        final user = snapshot.data as Map<String, String>;

        return AlertDialog(
          title: const Text('Perfil del Supervisor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              Text(user['name'] ?? 'Nombre no disponible', 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('ID: ${user['id'] ?? 'No disponible'}'),
              const SizedBox(height: 10),
              Text('Rol: ${user['role'] ?? 'No disponible'}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar Sesión'),
              onPressed: () {
                _logout(context);
              },
            ),
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, String>> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Recupera la información guardada en SharedPreferences
    String? userId = prefs.getString('userId');
    String? userName = prefs.getString('userName');
    String? userRole = prefs.getString('userRole');
    
    // Retorna un mapa con los datos del usuario
    return {
      'id': userId ?? 'No disponible',
      'name': userName ?? 'No disponible',
      'role': userRole ?? 'No disponible',
    };
  }

  void _logout(BuildContext context) {
    // Aquí deberías implementar la lógica para cerrar sesión.
    // Elimina los datos guardados en SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('userId');
      prefs.remove('userName');
      prefs.remove('userRole');
    });

    Navigator.of(context).pop(); // Cierra el diálogo
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) =>
              const LoginScreen()), // Navega a la pantalla de inicio de sesión
    );
  }
}
