//Este archivo configurará la navegación y mostrará la pantalla principal:

import 'package:flutter/material.dart';
import 'loggin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
