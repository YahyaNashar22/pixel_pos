import 'package:flutter/material.dart';
import 'package:pixel_pos/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("POS Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Mahmoud is gay!", style: AppTheme.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
