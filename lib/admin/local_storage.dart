import 'dart:convert';
import 'dart:html';
import 'package:fisma_inso2/models/user.dart';

void saveUserToLocalStorage(User user) {
  final userJson = jsonEncode(user.toJson());
  window.localStorage['user_${user.id}'] = userJson;
}

User? loadUserFromLocalStorage(String id) {
  final userJson = window.localStorage['user_$id'];
  if (userJson != null) {
    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    return User.fromJson(userMap);
  }
  return null;
}

void deleteUserFromLocalStorage(String id) {
  window.localStorage.remove('user_$id');
}

List<User> getAllUsersFromLocalStorage() {
  final users = <User>[];
  window.localStorage.forEach((key, value) {
    if (key.startsWith('user_')) {
      final userMap = jsonDecode(value) as Map<String, dynamic>;
      users.add(User.fromJson(userMap));
    }
  });
  return users;
}
