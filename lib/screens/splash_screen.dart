import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pixel_pos/data/database_company_service.dart';
import 'package:pixel_pos/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final DatabaseCompanyService _dbCompanyService = DatabaseCompanyService();

  void _init() async {
    await Future.delayed(const Duration(seconds: 3));
    bool companyExists = await _dbCompanyService.checkIfCompanyExists();
    if (!mounted) return;
    if (companyExists) {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.registerCompany);
    }
  }

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // Navigation logic after 3 seconds
    _init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/icon_logo.png",
                width: 500,
                height: 500,
              ),
              const SizedBox(height: 20),
              Text("Pixel POS", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
