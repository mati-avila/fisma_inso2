import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilteredList extends StatefulWidget {
  const FilteredList({super.key});

  @override
  _FilteredListState createState() => _FilteredListState();
}

class _FilteredListState extends State<FilteredList> {
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Obtener el ID del usuario
  }

  // Método para obtener la dirección aproximada desde coordenadas
  Future<String> getStreetFromCoordinates(double latitude, double longitude) async {
  try {
    // Obtener los resultados de geocodificación inversa
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    // Verificar si la lista no está vacía y tiene datos válidos
    if (placemarks.isNotEmpty) {
      // Intentar obtener el campo `street` del primer resultado
      String? street = placemarks.first.street;
      return street ?? 'Calle desconocida'; // Devolver 'Calle desconocida' si el campo es nulo
    } else {
      return 'Calle desconocida'; // No hay resultados de geocodificación
    }
  } catch (e) {
    debugPrint('Error al obtener la calle: $e');
    return 'Calle desconocida'; // Devolver un valor predeterminado en caso de error
  }
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

            if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No hay ubicaciones disponibles.'));
            }

            // Generar la lista de ubicaciones
            List<DocumentSnapshot> locations = streamSnapshot.data!.docs;

            return Expanded(
              child: ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  var doc = locations[index];
                  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

                  // Validar que los datos no sean nulos
                  if (data == null) {
                    return const ListTile(
                      title: Text('Datos inválidos'),
                    );
                  }

                  double latitude = data['latitude'] ?? 0.0;
                  double longitude = data['longitude'] ?? 0.0;
                  LatLng position = LatLng(latitude, longitude);

                  // Calcular distancia (ejemplo: del centro)
                  double distance = const Distance().as(
                    LengthUnit.Kilometer,
                    LatLng(-24.1857, -65.2993), // Coordenadas del centro
                    position,
                  );

                  // Usar FutureBuilder para obtener la calle desde las coordenadas
                  return FutureBuilder<String>(
                    future: getStreetFromCoordinates(latitude, longitude),
                    builder: (context, streetSnapshot) {
                      if (streetSnapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          title: Text('Cargando calle...'),
                        );
                      }

                      String street = streetSnapshot.data ?? 'Calle desconocida';

                      return ListTile(
                        title: Text(street),
                        trailing: Text('${distance.toStringAsFixed(1)} km'),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
