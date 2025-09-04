import 'package:flutter/material.dart';
import 'package:pixel_pos/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixel Pos',
      theme: AppTheme.darkTheme,
      home: Scaffold(
        appBar: AppBar(title: Text("Pixel Pos")),
        body: Center(child: Text("Pixel Pos")),
      ),
    );
  }
}
