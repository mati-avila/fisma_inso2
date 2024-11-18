// lib/services/user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisma_inso2/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> getUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error obteniendo usuarios: $e");
      return [];
    }
  }

  //Método que devuelve un Stream de usuarios desde Firestore
  Stream<List<User>> getUsersStream() {
    return _firestore
        .collection('users') // Asegúrate de que esta colección esté correcta
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return User.fromFirestore(doc); // Asumiendo que tienes un método 'fromFirestore'
          }).toList();
        });
  }

  List<User> filterAgenteSanitario(List<User> users) {
    return users.where((user) => user.rol == 'Agente Sanitario').toList();
  }

  List<User> searchUsers(List<User> users, String nombre, String apellido) {
    if (nombre.isEmpty && apellido.isEmpty) {
      return filterAgenteSanitario(users);
    }
    
    return users.where((user) {
      return user.nombre.toLowerCase().contains(nombre.toLowerCase()) &&
             user.apellido.toLowerCase().contains(apellido.toLowerCase());
    }).toList();
  }
}