import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../models/task.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_update_form.dart';

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  _TasksListPageState createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  late Stream<List<User>> _usersStream;
  
  @override
  void initState() {
    super.initState();
    _usersStream = _getAgentUsersStream();
  }

  Stream<List<User>> _getAgentUsersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: 'Agente Sanitario')
        .snapshots()
        .switchMap((usersSnapshot) {
      List<String> userIds = usersSnapshot.docs.map((doc) => doc.id).toList();
      
      if (userIds.isEmpty) {
        return Stream.value([]);
      }

      List<Stream<User>> userStreams = usersSnapshot.docs.map((userDoc) {
        Stream<List<Task>> tasksStream = FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('tasks')
            .snapshots()
            .map((tasksSnapshot) => tasksSnapshot.docs
                .map((taskDoc) => Task.fromFirestore(taskDoc))
                .toList());

        return tasksStream.map((tasks) {
          User user = User.fromFirestore(userDoc);
          user.tareas = tasks;
          return user;
        });
      }).toList();

      return Rx.combineLatestList(userStreams);
    });
  }

  void _showUpdateTaskDialog(Task task, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TaskUpdateForm(task: task, userId: userId);
      },
    );
  }

  Widget _buildTaskPriorityIcon(Task task) {
    if (task.isHighPriority) {
      return const Icon(Icons.priority_high, color: Colors.red);
    } else if (task.isMediumPriority) {
      return const Icon(Icons.adjust, color: Colors.orange);
    } else if (task.isLowPriority) {
      return const Icon(Icons.arrow_downward, color: Colors.green);
    }
    return const SizedBox.shrink();
  }

  Widget _buildTaskStatusChip(String status) {
    Color backgroundColor;
    String displayText;
    
    switch (status.toLowerCase()) {
      case 'pendiente':
        backgroundColor = Colors.orange;
        displayText = 'Pendiente';
        break;
      case 'en progreso':
        backgroundColor = Colors.blue;
        displayText = 'En Progreso';
        break;
      case 'completada':
        backgroundColor = Colors.green;
        displayText = 'Completada';
        break;
      default:
        backgroundColor = Colors.grey;
        displayText = status;
    }

    return Chip(
      label: Text(
        displayText,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas de Agentes Sanitarios'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<User>>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay agentes sanitarios disponibles.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              User agent = snapshot.data![index];
              
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(
                    '${agent.nombre} ${agent.apellido}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Total de tareas: ${agent.tareas.length}'),
                  children: agent.tareas.map((task) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: _buildTaskPriorityIcon(task),
                        title: Text(
                          task.description,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Fecha límite: ${DateFormat('dd/MM/yyyy').format(task.deadline)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            _buildTaskStatusChip(task.status),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showUpdateTaskDialog(task, agent.id),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}