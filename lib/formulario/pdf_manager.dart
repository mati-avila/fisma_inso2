import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart'; // Para obtener directorios locales
import 'dart:io'; // Para manejar archivos en el sistema local
import 'package:share_plus/share_plus.dart'; // Para compartir archivos generados

class PdfManager {
  // Función asíncrona para generar y guardar un PDF
  Future<void> generateAndSavePdf(
      String idVisita,
      String idFamilia,
      String numSector,
      String numCasa,
      String nomTitular,
      String direccion,
      String numTelefono,
      String? tipoCasa,
      String? tipoFamilia,
      String coordinates,
      Map<String, String> resultados) async {
    // Crear un documento PDF usando el paquete 'pdf'
    final pdf = pw.Document();

    // Añadir contenido al PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Formulario 833',
                style:
                    pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 18),
            pw.Text('ID de Visita: $idVisita'),
            pw.SizedBox(height: 6),
            pw.Text('ID de Familia: $idFamilia'),
            pw.SizedBox(height: 6),
            pw.Text('El número de sector es: $numSector'),
            pw.SizedBox(height: 6),
            pw.Text('Número de Casa: $numCasa'),
            pw.SizedBox(height: 6),
            pw.Text('Nombre de Titular: $nomTitular'),
            pw.SizedBox(height: 6),
            pw.Text('Dirección: $direccion'),
            pw.SizedBox(height: 6),
            pw.Text('Número de Teléfono: $numTelefono'),
            pw.SizedBox(height: 6),
            pw.Text('Ubicación (Latitud, Longitud): $coordinates'),
            pw.SizedBox(height: 6),
            pw.Text('Tipo de Casa: ${tipoCasa ?? "No especificado"}'),
            pw.SizedBox(height: 6),
            pw.Text('Tipo de Familia: ${tipoFamilia ?? "No especificado"}'),
            pw.SizedBox(height: 6),
            pw.Text('Discapacidad: ${resultados["Discapacidad"]}'),
            pw.SizedBox(height: 6),
            pw.Text('Enfermedades: ${resultados["Enfermedades"]}'),
            pw.SizedBox(height: 6),
            pw.Text('Beneficio Social: ${resultados["Beneficio Social"]}'),
            pw.SizedBox(height: 6),
            pw.Text('Vacunas: ${resultados["Vacunas"]}'),
            pw.SizedBox(height: 6),
            pw.Text('Factores de Riesgo: ${resultados["Factores de Riesgo"]}'),
            pw.SizedBox(height: 6),
          ],
        ),
      ),
    );

    /*// Guardar el archivo en el sistema de archivos local
    final outputDir = await getTemporaryDirectory();
    final file = File("${outputDir.path}/formulario_833.pdf");
    await file.writeAsBytes(await pdf.save());

    // Opción para compartir el archivo generado
    Share.shareFiles([file.path], text: 'Formulario 833 generado.');
    //final result = await Share.shareXFiles([XFile(file.path)], text: 'Formulario 833 generado.');*/

    // Guardar el archivo en el sistema de archivos local
    final outputDir = await getTemporaryDirectory();
    final file = File("${outputDir.path}/formulario_833.pdf");
    await file.writeAsBytes(await pdf.save());
    print('Ruta del directorio de salida: ${outputDir.path}');

    // Opción para compartir el archivo generado usando shareXFiles
    await Share.shareXFiles([XFile(file.path)],
        text: 'Formulario 833 generado.');
  }
}
