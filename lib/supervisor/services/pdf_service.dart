// lib/services/pdf_service.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:fisma_inso2/models/user.dart';

class PdfService {
  Future<void> downloadSelectedTasks(List<User> users) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Tareas de Agentes Sanitarios',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)
              ),
              pw.SizedBox(height: 20),
              ...users.map((user) => _buildUserTasksSection(user)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildUserTasksSection(User user) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Usuario: ${user.nombre} ${user.apellido}',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)
        ),
        pw.Text('Tareas:'),
        ...user.tareas.map((task) => pw.Text(
          '• ${task.description}',
          style: const pw.TextStyle(fontSize: 14)
        )),
        pw.SizedBox(height: 10),
      ],
    );
  }
}