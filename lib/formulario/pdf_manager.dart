import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';

class PdfManager {
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
    final pdf = pw.Document();

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
            pw.Text('El numero de sector es: $numSector'),
            pw.SizedBox(height: 6),
            pw.Text('Numero de Casa: $numCasa'),
            pw.SizedBox(height: 6),
            pw.Text('Nombre de Titular: $nomTitular'),
            pw.SizedBox(height: 6),
            pw.Text('Dirección: $direccion'),
            pw.SizedBox(height: 6),
            pw.Text('Numero de Telefono: $numTelefono'),
            pw.SizedBox(height: 6),
            pw.Text(
                'La ubicacion de casa es (Latitud y longitud): $coordinates'),
            pw.SizedBox(height: 6),
            pw.Text('Tipo de Casa: $tipoCasa'),
            pw.SizedBox(height: 6),
            pw.Text('Tipo de Familia: $tipoFamilia'),
            pw.SizedBox(height: 6),
            pw.Text('Discapacidad: ${resultados["Discapacidad"]}'),
            pw.SizedBox(height: 6),
            pw.Text('Enfermedades: ${resultados["Enfermedades"]}'),
            pw.SizedBox(height: 6),
            pw.Text('Beneficio Social: ${resultados["Beneficio Social"]}'),
            pw.SizedBox(height: 6),
            pw.Text('Vacunas seleccionadas: ${resultados["Vacunas"]}'),
            pw.SizedBox(height: 6),
            pw.Text('Factores de Riesgo: ${resultados["Factores de Riesgo"]}'),
            pw.SizedBox(height: 6),
          ],
        ),
      ),
    );

    //await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
