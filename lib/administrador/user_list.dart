import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/agent_model.dart';
import 'package:fisma_inso2/base_datos/data_storage.dart';
import 'user_list_item.dart';
import 'user_dialog.dart';

class UserList extends StatefulWidget {
  final String userType;
  final String searchQuery;

  UserList({required this.userType, required this.searchQuery});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<List<Agent>> _agentsFuture;
  List<Agent> _agents = [];

  @override
  void initState() {
    super.initState();
    _agentsFuture = DataStorage.loadAgents().then((agents) {
      _agents = agents;
      return agents;
    });
  }

  void _addAgent(Agent agent) async {
    setState(() {
      _agents.add(agent);
    });
    await DataStorage.saveAgents(_agents);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Agent>>(
      future: _agentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        List<Agent> agents = snapshot.data ?? [];

        List<Agent> filteredAgents = agents
            .where((agent) =>
                agent.rol == widget.userType &&
                (agent.nombre.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
                agent.apellido.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
                agent.estadoDeTareas.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
                agent.fechaUltimoAcceso.toLowerCase().contains(widget.searchQuery.toLowerCase())))
            .toList();

        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Mostrar diálogo para añadir nuevo usuario
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UserDialog(
                      onSave: (newAgent) {
                        _addAgent(newAgent);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              child: Text('Añadir Usuario'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAgents.length,
                itemBuilder: (context, index) {
                  Agent agent = filteredAgents[index];
                  return UserListItem(
                    agent: agent,
                    onDelete: () {
                      setState(() {
                        _agents.remove(agent);
                      });
                      DataStorage.saveAgents(_agents);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
