import 'package:flutter/material.dart';
import 'package:pixel_pos/screens/pos_invoices_screen.dart';
import 'package:pixel_pos/screens/pos_order_screen.dart';
import 'package:pixel_pos/screens/pos_tables_screen.dart';
import 'package:pixel_pos/theme/app_theme.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  int _selectedIndex = 0;
  int? _selectedInvoiceId;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index, {int? invoiceId}) {
    setState(() {
      if (index == 0 && _selectedIndex == 0) {
        // already on PosOrderScreen, reset it
        _selectedInvoiceId = null;
      } else {
        _selectedInvoiceId = invoiceId;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      PosOrderScreen(
        key: ValueKey(_selectedInvoiceId),
        onTabChange: _onItemTapped,
        invoiceId: _selectedInvoiceId,
      ),
      PosTablesScreen(onTabChange: _onItemTapped),
      PosInvoicesScreen(onTabChange: _onItemTapped),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("POS")),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppTheme.primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "New"),
          BottomNavigationBarItem(icon: Icon(Icons.table_bar), label: "Tables"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Invoices"),
        ],
      ),
    );
  }
}
