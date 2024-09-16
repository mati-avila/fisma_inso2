import 'package:flutter/material.dart';
import 'package:fisma_inso2/models/agent_model.dart';
import 'add_user_form.dart';

class UserDialog extends StatefulWidget {
  final Agent? agent;
  final void Function(Agent) onSave;

  UserDialog({this.agent, required this.onSave});

  @override
  _UserDialogState createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.agent != null ? 'Editar Usuario' : 'Agregar Nuevo Usuario'),
      content: SingleChildScrollView(
        child: AddUserForm(
          agent: widget.agent,
          onSave: widget.onSave,
        ),
      ),
    );
  }
}
