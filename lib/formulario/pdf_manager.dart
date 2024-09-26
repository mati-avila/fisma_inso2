import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // Para imprimir y compartir PDF
import 'package:pdf/pdf.dart'; // Para trabajar con PdfPageFormat

class PdfManager {
  // Función asíncrona para generar y mostrar un PDF utilizando el paquete 'printing'
  Future<void> generateAndPrintPdf(
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
        pageFormat: PdfPageFormat.a4, // Especificar el formato de la página
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
            pw.Text('Discapacidad: ${resultados["Discapacidad"] ?? "N/A"}'),
            pw.SizedBox(height: 6),
            pw.Text('Enfermedades: ${resultados["Enfermedades"] ?? "N/A"}'),
            pw.SizedBox(height: 6),
            pw.Text(
                'Beneficio Social: ${resultados["Beneficio Social"] ?? "N/A"}'),
            pw.SizedBox(height: 6),
            pw.Text('Vacunas: ${resultados["Vacunas"] ?? "N/A"}'),
            pw.SizedBox(height: 6),
            pw.Text(
                'Factores de Riesgo: ${resultados["Factores de Riesgo"] ?? "N/A"}'),
            pw.SizedBox(height: 6),
          ],
        ),
      ),
    );

    // Imprimir y mostrar una vista previa del archivo PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
