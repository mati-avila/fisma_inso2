import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({Key? key}) : super(key: key);

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
          SizedBox(height: 20),
          Text('Nombre del Agente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('ID: 12345'),
          SizedBox(height: 10),
          Text('Rol: Asistente Social'),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cerrar Sesión'),
          onPressed: () {
            // Implementar funcionalidad de cerrar sesión
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
  }

  void _logout(BuildContext context) {
    // Aquí deberías implementar la lógica para cerrar sesión.
    // Por ejemplo, podrías redirigir al usuario a la pantalla de inicio de sesión o eliminar el token de autenticación.

    Navigator.of(context).pop(); // Cierra el diálogo
    // Navega a la pantalla de inicio de sesión o realiza el proceso de cierre de sesión
  }
}
