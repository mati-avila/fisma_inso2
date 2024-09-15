import 'package:flutter/material.dart';
import 'loggin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat', // Aplica la fuente Montserrat globalmente
        primarySwatch: Colors.blue, // Cambia el color primario de la aplicación
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue, // Color del texto de los botones
            textStyle: TextStyle(
              fontSize: 16, // Tamaño de fuente en los botones
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            textStyle: TextStyle(
              fontSize: 16, // Tamaño de fuente en los botones TextButton
            ),
          ),
        ),
        // Puedes agregar más configuraciones de tema aquí según sea necesario
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
