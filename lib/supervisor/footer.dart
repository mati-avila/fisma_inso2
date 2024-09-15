import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                // Acción para la página web
                print('Ir a la página web');
              },
              child: const Text(
                'Página web',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            InkWell(
              onTap: () {
                // Acción para Acerca de
                print('Acerca de');
              },
              child: const Text(
                'Acerca de',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            InkWell(
              onTap: () {
                // Acción para Soporte
                print('Soporte');
              },
              child: const Text(
                'Soporte',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
