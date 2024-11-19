import 'package:flutter/material.dart';
import 'AddIndicatorScreen.dart';

class MapOptions extends StatelessWidget {
  const MapOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: const Text(
          'Opciones del Mapa',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 47, 83, 102),
          ),
        ),
        children: [
          _buildMapOption(
            icon: Icons.download,
            label: 'Descargar pdf del mapa',
            onTap: () {
              // Implementar funcionalidad de descarga
            },
          ),
          _buildMapOption(
            icon: Icons.location_on,
            label: 'Ver ruta eficiente',
            onTap: () {
              // Implementar funcionalidad para ver indicadores
            },
          ),
          _buildMapOption(
            icon: Icons.add_location,
            label: 'Añadir Indicadores',
            onTap: () {
              // Navegar a la pantalla de añadir indicadores
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddIndicatorScreen()),
              );
            },
          ),
          _buildMapOption(
            icon: Icons.share,
            label: 'Compartir mapa',
            onTap: () {
              // Implementar funcionalidad para compartir
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 92, 198, 255)),
      title: Text(label),
      onTap: onTap,
    );
  }
}
