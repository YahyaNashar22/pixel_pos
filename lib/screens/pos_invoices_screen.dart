import 'package:flutter/material.dart';

class PosInvoicesScreen extends StatelessWidget {
  final void Function(int, {int? invoiceId}) onTabChange;
  const PosInvoicesScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Invoices Screen"));
  }
}
