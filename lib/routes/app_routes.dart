import 'package:flutter/material.dart';
import 'package:pixel_pos/screens/home_screen.dart';
import 'package:pixel_pos/screens/not_found_screen.dart';
import 'package:pixel_pos/screens/splash_screen.dart';

class AppRouter {
  // Define route names as constants
  static const splash = "/";
  static const home = "/home";

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}
