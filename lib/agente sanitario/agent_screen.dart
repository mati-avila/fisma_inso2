import 'package:flutter/material.dart';
import 'map_options.dart';
import 'package:fisma_inso2/models/profile_dialogs.dart';
import 'sidebar_menu.dart';
import 'map_view.dart';
import 'form_buttons.dart';
import 'filtered_list.dart';

class AgentScreen extends StatelessWidget {
  const AgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Social'),
        backgroundColor: Color.fromARGB(255, 148, 182, 201),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showProfileDialog(context),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 300,
            color: Colors.grey[200],
            child: const SidebarMenu(),
          ),
          // Main content
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column: Map view with overlaid options
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          // Welcome message
                          Text(
                            '¡Bienvenido/a, Agente!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 47, 83, 102),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          // Map view with overlaid options
                          Expanded(
                            child: Stack(
                              children: [
                                // Map view
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: const MapView(),
                                  ),
                                ),
                                // Overlaid Map options
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                  child: const MapOptions(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Right column: Form buttons and Filtered list
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          const FormButtons(),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: FilteredList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ProfileDialog();
      },
    );
  }
}
