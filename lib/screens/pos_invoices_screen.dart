import 'package:flutter/material.dart';
import 'package:pixel_pos/data/database_invoice_service.dart';

class PosInvoicesScreen extends StatefulWidget {
  final void Function(int, {int? invoiceId}) onTabChange;
  const PosInvoicesScreen({super.key, required this.onTabChange});

  @override
  State<PosInvoicesScreen> createState() => _PosInvoicesScreenState();
}

class _PosInvoicesScreenState extends State<PosInvoicesScreen> {
  final DatabaseInvoiceService _dbInvoicesService = DatabaseInvoiceService();
  List<Map<String, dynamic>> _invoices = [];

  Future<void> _fetchInvoices() async {
    final result = await _dbInvoicesService.getAllInvoices('closed');
    setState(() {
      _invoices = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return _invoices.isEmpty
        ? const Center(child: Text('No previous invoices'))
        : ListView.builder(
            itemCount: _invoices.length,
            itemBuilder: (context, index) {
              final invoice = _invoices[index];
              return ListTile(
                title: Text(invoice['name']),
                onTap: () => widget.onTabChange(0, invoiceId: invoice['id']),
              );
            },
          );
  }
}
