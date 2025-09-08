import 'package:flutter/material.dart';
import 'package:pixel_pos/data/database_invoice_service.dart';

class PosTablesScreen extends StatefulWidget {
  final void Function(int, {int? invoiceId}) onTabChange;
  const PosTablesScreen({super.key, required this.onTabChange});

  @override
  State<PosTablesScreen> createState() => _PosTablesScreenState();
}

class _PosTablesScreenState extends State<PosTablesScreen> {
  final DatabaseInvoiceService _dbInvoicesService = DatabaseInvoiceService();
  List<Map<String, dynamic>> _tables = [];

  Future<void> _fetchInvoices() async {
    final result = await _dbInvoicesService.getAllInvoices('pending');
    setState(() {
      _tables = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return _tables.isEmpty
        ? const Center(child: Text('No open tables'))
        : GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2 / 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _tables.length,
            itemBuilder: (context, index) {
              final table = _tables[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    widget.onTabChange(0, invoiceId: table['id']);
                  },
                  child: Center(child: Text(table['name'])),
                ),
              );
            },
          );
  }
}
