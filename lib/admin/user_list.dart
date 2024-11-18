import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisma_inso2/models/user.dart';
import 'user_form.dart';
import 'user_details.dart';
import 'package:fisma_inso2/loggin.dart';
import 'dart:async';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _usersSubscription;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _usersSubscription?.cancel();
    super.dispose();
  }

  void _loadUsers() {
    _usersSubscription = _firestore.collection('users').snapshots().listen((snapshot) {
      setState(() {
        _users = snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
        _filteredUsers = _users;
      });
    });
  }

  Future<void> _addUser(User user) async {
    // Verificar si el correo ya está registrado
    final correoExistente = _users.any((u) => u.correo == user.correo);
    if (correoExistente) {
      _showErrorDialog("El correo electrónico ya está registrado.");
      return;
    }

    try {
      await _firestore.collection('users').add(user.toFirestore());
    } catch (e) {
      _showErrorDialog("Error al agregar el usuario.");
    }
  }

  Future<void> _updateUser(User updatedUser) async {
    // Verificar si el correo ya está registrado
    final correoExistente = _users.any((u) =>
        u.correo == updatedUser.correo && u.id != updatedUser.id); // No considerar el usuario que se está editando
    if (correoExistente) {
      _showErrorDialog("El correo electrónico ya está registrado.");
      return;
    }

    try {
      await _firestore.collection('users').doc(updatedUser.id).update(updatedUser.toFirestore());
    } catch (e) {
      _showErrorDialog("Error al actualizar el usuario.");
    }
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      _showErrorDialog("Error al eliminar el usuario.");
    }
  }

  void _showUserForm(BuildContext context, {User? userToEdit}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: UserFormScreen(
              onSubmit: userToEdit == null ? _addUser : _updateUser,
              userToEdit: userToEdit,
              existingUsers: _users, // Pasa la lista de usuarios existentes
            ),
          ),
        );
      },
    );
  }

  void _viewUserDetails(User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => UserDetailsScreen(
          user: user,
          onUpdate: _updateUser,
          onDelete: _deleteUser,
          existingUsers: _users, // Pasa la lista de usuarios existentes
        ),
      ),
    );
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _users.where((user) {
        final fullName = '${user.apellido} ${user.nombre}'.toLowerCase();
        final searchLower = query.toLowerCase();
        return fullName.contains(searchLower);
      }).toList();
    });
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => LoginScreen(),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administrador'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar usuarios...',
                prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron usuarios.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (ctx, index) {
                      final user = _filteredUsers[index];
                      return Card(
                        color: Colors.grey[100],
                        margin: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            '${user.apellido}, ${user.nombre}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Estado: ${user.estado} | Último acceso: ${user.fechaUltimoAcceso.toLocal()} | Rol: ${user.rol}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          leading: Icon(
                            Icons.person,
                            color: Colors.blue[800],
                          ),
                          onTap: () => _viewUserDetails(user),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUserForm(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar Usuario',
      ),
    );
  }
}
