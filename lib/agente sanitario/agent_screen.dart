//Este archivo será la estructura principal de la pantalla del agente.

import 'package:flutter/material.dart';
import 'sidebar_menu.dart';
import 'map_view.dart';
import 'form_buttons.dart';
import 'filtered_list.dart';

class AgentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio - Asistente Social'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundImage: NetworkImage('https://www.example.com/profile.jpg'), // Imagen de ejemplo
          )
        ],
      ),
      drawer: Drawer(
        child: SidebarMenu(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SidebarMenu(),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bienvenido/a Agente', style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: 20),
                  DropdownButton<String>(
                    items: [
                      DropdownMenuItem(value: 'Categoría 1', child: Text('Categoría 1')),
                      DropdownMenuItem(value: 'Categoría 2', child: Text('Categoría 2')),
                    ],
                    onChanged: (value) {},
                    hint: Text('Categoría'),
                  ),
                  Expanded(child: MapView()), // Aquí se incluye el mapa
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  FormButtons(),
                  SizedBox(height: 20),
                  FilteredList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
