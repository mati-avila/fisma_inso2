import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: const MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng centerPoint = const LatLng(-24.1857, -65.2993); // Coordenadas iniciales

  // Método para obtener el ID del usuario desde SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Obtener el ID del usuario
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No se encontró el usuario.'));
        }

        String userId = snapshot.data!;

        // Escucha los cambios en tiempo real de la subcolección "ubications"
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('ubications')
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!streamSnapshot.hasData) {
              return const Center(child: Text('No hay ubicaciones disponibles.'));
            }

            // Generar los marcadores en tiempo real
            List<Marker> markers = streamSnapshot.data!.docs.map((doc) {
              LatLng position = LatLng(doc['latitude'], doc['longitude']);
              return Marker(
                point: position,
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    // Lógica para manejar el toque en el marcador
                  },
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              );
            }).toList();

            return FlutterMap(
              options: MapOptions(
                center: centerPoint,
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: markers, // Mostrar los marcadores en tiempo real
                ),
              ],
            );
          },
        );
      },
    );
  }
}
