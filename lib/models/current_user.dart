// models/current_user.dart
import 'package:flutter/foundation.dart';

class CurrentUser with ChangeNotifier {
  String? id;
  String? nombre;
  String? correo;
  String? rol;

  // Establecer el usuario actual
  void setUser(String id, String nombre, String correo, String rol) {
    this.id = id;
    this.nombre = nombre;
    this.correo = correo;
    this.rol = rol;
    notifyListeners();
  }

  // Limpiar los datos del usuario
  void clearUser() {
    id = null;
    nombre = null;
    correo = null;
    rol = null;
    notifyListeners();
  }
}
