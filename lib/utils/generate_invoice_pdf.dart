import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pixel_pos/services/session_manager.dart';
import 'package:intl/intl.dart';

pw.Document generateInvoicePdf({
  required String invoiceName,
  required List<Map<String, dynamic>> products,
}) {
  final SessionManager _session = SessionManager();
  final formatter = NumberFormat('#,###');
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(
        70 * PdfPageFormat.mm,
        double.infinity,
        marginAll: 5 * PdfPageFormat.mm,
      ),
      build: (context) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,

            children: [
              pw.Text(
                _session.currentCompany!.name,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                invoiceName,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Divider(),
              pw.ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final prod = products[index];
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(prod['name'], style: pw.TextStyle(fontSize: 12)),
                      pw.Text(
                        '${prod['price'] % 1 == 0 ? formatter.format(prod['price'].toInt()) : formatter.format(prod['price'])} LBP',
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    '${formatter.format(products.fold(0.0, (sum, p) => sum + (p['price'] as double)))} LBP',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Thank you for your order!',
                style: pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        );
      },
    ),
  );

  return pdf;
}
