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
    return prefs.getString('userId');
  }

  Future<String> getStreetFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        String? street = placemarks.first.street;
        return street ?? 'Calle desconocida';
      } else {
        return 'Calle desconocida';
      }
    } catch (e) {
      debugPrint('Error al obtener la calle: $e');
      return 'Calle desconocida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<String?>(
              future: getUserId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No se encontró el usuario.'));
                }

                String userId = snapshot.data!;

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

                    List<DocumentSnapshot> locations = streamSnapshot.data!.docs;

                    return ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        var doc = locations[index];
                        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

                        if (data == null) {
                          return const ListTile(
                            title: Text('Datos inválidos'),
                          );
                        }

                        double latitude = data['latitude'] ?? 0.0;
                        double longitude = data['longitude'] ?? 0.0;
                        LatLng position = LatLng(latitude, longitude);

                        double distance = const Distance().as(
                          LengthUnit.Kilometer,
                          LatLng(-24.1857, -65.2993),
                          position,
                        );

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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}