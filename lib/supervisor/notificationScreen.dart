import 'package:flutter/material.dart';
import 'notifications_panel.dart';

class NotificationsScreen extends StatelessWidget {
  final String userId;

  const NotificationsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
              
        
      ),
    );
  }
}
