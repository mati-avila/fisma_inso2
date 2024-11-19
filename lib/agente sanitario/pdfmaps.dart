import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';

class MapPdfGenerator {
  // Método para obtener el ID del usuario desde SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Obtener el ID del usuario
  }

  // Método para generar el PDF
  Future<void> generateMapPdf(BuildContext context, double zoomLevel, LatLng centerPoint) async {
    String? userId = await getUserId();

    if (userId == null) {
      return;
    }

    // Obtener las ubicaciones desde Firestore
    QuerySnapshot ubicationsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('ubications')
        .get();

    // Crear el documento PDF
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Mapa con Marcadores'),
              pw.Text('Zoom: $zoomLevel'),
              pw.Text('Centro del Mapa: ${centerPoint.latitude}, ${centerPoint.longitude}'),
              pw.SizedBox(height: 20),
              pw.Text('Ubicaciones:'),
              pw.ListView.builder(
                itemCount: ubicationsSnapshot.docs.length,
                itemBuilder: (context, index) {
                  var doc = ubicationsSnapshot.docs[index];
                  double lat = doc['latitude'];
                  double lng = doc['longitude'];
                  return pw.Text('Marcador ${index + 1}: ($lat, $lng)');
                },
              ),
            ],
          );
        },
      ),
    );

    // Guardar el PDF y mostrar la opción de impresión
    Uint8List pdfBytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (format) => pdfBytes);
  }
}
