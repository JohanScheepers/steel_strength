// lib/services/pdf_report.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:steel_strength/models/steel_section.dart';

// Helper for PDF colors (since pdf package uses its own color class)
class PdfColors {
  static final green = pdf.PdfColor.fromHex('#4CAF50');
  static final red = pdf.PdfColor.fromHex('#F44336');
}

class PdfReportService {
  /// Generates a PDF file with the calculation results and returns the file path.
  static Future<String> generatePdf({
    required SteelSection section,
    required double designMoment,
    required double capacity,
    required double utilization,
    required bool isSafe,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Steel Strength Calculation Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('Section: ${section.designation}'),
            pw.Text('Design Moment: ${designMoment.toStringAsFixed(2)} kNm'),
            pw.Text('Capacity: ${capacity.toStringAsFixed(2)} kNm'),
            pw.Text('Utilization: ${utilization.toStringAsFixed(1)}%'),
            pw.Text('Status: ${isSafe ? "Safe" : "Unsafe"}',
                style: pw.TextStyle(
                    color: isSafe ? PdfColors.green : PdfColors.red)),
            pw.SizedBox(height: 24),
            pw.Text('Section Properties', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(data: <List<String>>[
              ['Property', 'Value'],
              ['Designation', section.designation],
              ['Height (h)', '${section.h} mm'],
              ['Width (b)', '${section.b} mm'],
              ['Flange thickness (tf)', '${section.tf} mm'],
              ['Web thickness (tw)', '${section.tw} mm'],
              ['Section modulus (Sx)', '${section.Sx} mm³'],
            ]),
          ],
        ),
      ),
    );

    final outputDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${outputDir.path}/steel_report_$timestamp.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return filePath;
  }
}
