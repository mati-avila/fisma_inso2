import 'package:flutter/material.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    // Este es solo un contenedor de ejemplo para representar el mapa
    return Container(
      color: Colors.blue[100],
      child: const Center(
        child: Text('Vista del Mapa'),
      ),
    );
  }
}
