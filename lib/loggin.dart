import 'package:flutter/material.dart';
import 'agente sanitario/agent_screen.dart'; // Asegúrate de importar el archivo donde definiste HomeScreen

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100]!, Color.fromARGB(255, 197, 226, 250)!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(size: 100),
                  SizedBox(height: 50),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    child: Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 168, 209, 250),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Navegar a la página de inicio
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AgentScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    child: Text('¿Olvidaste tu contraseña?', style: TextStyle(color: const Color.fromARGB(255, 17, 0, 0))),
                    onPressed: () {
                      // Aquí iría la lógica para recuperar la contraseña
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}