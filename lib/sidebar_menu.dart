//Este archivo contendrá las opciones del menú lateral.

import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.category),
          title: Text('Seleccionar Categoría'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Configuración'),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Cerrar Sesión'),
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notificaciones'),
        ),
      ],
    );
  }
}
