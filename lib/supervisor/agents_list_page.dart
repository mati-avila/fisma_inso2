import 'package:flutter/material.dart';
import 'agents_data.dart'; // Importar datos de agentes
import 'agents_table.dart'; // Para el widget AgentsTable
import 'task_assignment_form.dart'; // Formulario para asignación de tareas

class AgentsListPage extends StatefulWidget {
  const AgentsListPage({super.key});

  @override
  _AgentsListPageState createState() => _AgentsListPageState();
}

class _AgentsListPageState extends State<AgentsListPage> {
  Set<Agent> selectedAgents = {}; // Conjunto de agentes seleccionados
  int _taskIdCounter = 1; // Contador para generar IDs de tareas

  void _showTaskAssignmentDialog() {
    if (selectedAgents.length > 1) {
      // Mostrar advertencia si se seleccionan más de un agente
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Advertencia'),
            content: const Text('No se puede seleccionar más de un agente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (selectedAgents.isNotEmpty) {
      // Mostrar formulario de asignación de tareas si se selecciona un agente
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final taskId = (_taskIdCounter++).toString();
          return TaskAssignmentForm(
            agent: selectedAgents.first,
            taskId: taskId,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Agentes Sanitarios'),
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centra el contenido
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 32,
                  ),
                  child: AgentsTable(
                    textStyle: const TextStyle(fontSize: 14),
                    agent: [], // No mostrar resultados de búsqueda aquí
                    agentes: agentes, // Mostrar todos los agentes
                    onAgentSelected: (agent) {
                      setState(() {
                        if (selectedAgents.contains(agent)) {
                          selectedAgents.remove(agent);
                        } else {
                          selectedAgents.add(agent);
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200, // Ancho fijo del botón
              child: ElevatedButton(
                onPressed: _showTaskAssignmentDialog,
                child: const Text('Siguiente'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12), // Ajusta el alto del botón
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
