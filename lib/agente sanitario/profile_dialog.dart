import 'package:fisma_inso2/loggin.dart';
import 'package:flutter/material.dart';
import 'package:fisma_inso2/loggin.dart'; // Asegúrate de importar la pantalla de inicio de sesión

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Perfil del Agente'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          const Text('Nombre del Agente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('ID: 12345'),
          const SizedBox(height: 10),
          const Text('Rol: Asistente Social'),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cerrar Sesión'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
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
  }

  void _logout(BuildContext context) {
    // Aquí deberías implementar la lógica para cerrar sesión.
    // Por ejemplo, podrías eliminar el token de autenticación.

    Navigator.of(context).pop(); // Cierra el diálogo
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Redirige a la pantalla de inicio de sesión
    );
  }
}
