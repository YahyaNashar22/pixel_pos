import 'package:flutter/material.dart';
import 'package:pixel_pos/routes/app_routes.dart';
import 'package:pixel_pos/theme/app_theme.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI for Windows/Linux/Mac
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const PixelPosApp());
}

class PixelPosApp extends StatelessWidget {
  const PixelPosApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixel Pos',
      theme: AppTheme.darkTheme,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
