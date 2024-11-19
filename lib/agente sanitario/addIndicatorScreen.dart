import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddIndicatorScreen extends StatefulWidget {
  const AddIndicatorScreen({super.key});

  @override
  _AddIndicatorScreenState createState() => _AddIndicatorScreenState();
}

class _AddIndicatorScreenState extends State<AddIndicatorScreen> {
  List<Marker> markers = []; // Lista de indicadores agregados
  MapController mapController = MapController();
  LatLng centerPoint = const LatLng(-24.1857, -65.2993); // Coordenadas iniciales
  LatLng currentCenter = const LatLng(-24.1857, -65.2993); // Coordenadas actuales del puntero
  bool isMarking = false; // Estado para saber si estamos marcando
  double zoomLevel = 13.0; // Nivel de zoom actual

  // Método para obtener el ID del usuario desde SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Usamos la misma clave que usaste para guardar el ID
  }

  // Método para cargar las ubicaciones ya guardadas de Firestore
  void _loadMarkers() async {
    String? userId = await getUserId();
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('ubications') // Subcolección de ubicaciones
          .get()
          .then((querySnapshot) {
        // Recorrer todos los documentos y agregar los marcadores
        setState(() {
          markers = querySnapshot.docs.map((doc) {
            LatLng position = LatLng(doc['latitude'], doc['longitude']);
            return Marker(
              point: position,
              builder: (ctx) => GestureDetector(
                onTap: () {
                  _removeMarker(position); // Eliminar el marcador al tocarlo
                },
                child: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          }).toList();
        });
      });
    }
  }

  // Método para agregar un marcador
  void _addMarker(LatLng position) async {
    String? userId = await getUserId(); // Obtener el ID del usuario

    if (userId == null) {
      // Si no se encontró el ID del usuario, mostrar un mensaje de error o redirigir
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No se encontró el ID del usuario."),
      ));
      return;
    }

    // Usar el ID del usuario para crear una colección específica para este usuario
    await FirebaseFirestore.instance
        .collection('users') // Aquí se crea la colección "users" si no existe
        .doc(userId) // Usamos el ID del usuario como el documento principal
        .collection('ubications') // Esta es la subcolección de "ubicaciones" dentro del documento del usuario
        .add({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      markers.add(Marker(
        point: position,
        builder: (ctx) => GestureDetector(
          onTap: () {
            _removeMarker(position); // Eliminar el marcador al tocarlo
          },
          child: Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40,
          ),
        ),
      ));
    });
  }

  // Método para eliminar un marcador
  void _removeMarker(LatLng position) async {
    // Mostrar diálogo de confirmación
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar marcador"),
          content: const Text("¿Estás seguro de que deseas eliminar este marcador?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancelar
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmar
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );

    // Si el usuario confirma, proceder a eliminar el marcador
    if (confirm == true) {
      String? userId = await getUserId();
      if (userId != null) {
        // Buscar y eliminar el documento correspondiente en Firestore
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('ubications')
            .where('latitude', isEqualTo: position.latitude)
            .where('longitude', isEqualTo: position.longitude)
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete(); // Eliminar documento
          }
        });
      }

      setState(() {
        markers.removeWhere((marker) => marker.point == position); // Eliminar de la lista local
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Marcador eliminado")),
      );
    }
  }

  // Método para activar o desactivar el modo de marcar
  void _toggleMarking() {
    setState(() {
      isMarking = !isMarking;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers(); // Cargar los marcadores al inicio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Indicadores'),
        actions: [
          IconButton(
            icon: Icon(isMarking ? Icons.stop : Icons.pin_drop),
            onPressed: _toggleMarking, // Cambiar entre marcar y no marcar
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Coordenadas: ${currentCenter.latitude.toStringAsFixed(5)}, ${currentCenter.longitude.toStringAsFixed(5)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: centerPoint, // Coordenadas de San Salvador de Jujuy
                zoom: zoomLevel,
                minZoom: 10,
                maxZoom: 18, // Permitir mayor zoom
                onPositionChanged: (position, hasGesture) {
                  // Actualizar el puntero central al mover el mapa
                  setState(() {
                    currentCenter = position.center!;
                    zoomLevel = position.zoom!;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    // Puntero móvil en el centro
                    Marker(
                      point: currentCenter,
                      builder: (ctx) => Transform.rotate(
                        angle: 0, // Mantener el puntero siempre vertical
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 50,
                        ),
                      ),
                    ),
                    ...markers, // Marcadores adicionales agregados
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isMarking) {
            _addMarker(currentCenter); // Agregar marcador si estamos en modo marcar
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
