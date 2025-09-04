import 'package:flutter/material.dart';
import 'package:pixel_pos/screens/home_screen.dart';
import 'package:pixel_pos/screens/login_screen.dart';
import 'package:pixel_pos/screens/not_found_screen.dart';
import 'package:pixel_pos/screens/register_company_screen.dart';
import 'package:pixel_pos/screens/splash_screen.dart';

class AppRouter {
  // Define route names as constants
  static const splash = "/";
  static const home = "/home";
  static const login = "/login";
  static const registerCompany = "/register-company";

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerCompany:
        return MaterialPageRoute(builder: (_) => const RegisterCompanyScreen());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}
