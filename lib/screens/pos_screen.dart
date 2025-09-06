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

  final List<Widget> _screens = [
    PosOrderScreen(),
    PosTablesScreen(),
    PosInvoicesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("POS")),
      body: _screens[_selectedIndex],
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
