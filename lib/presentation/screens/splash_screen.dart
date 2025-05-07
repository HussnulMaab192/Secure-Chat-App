import 'dart:async';

import 'package:chat_app_secure_programming/providers/auth_provider.dart';
import 'package:chat_app_secure_programming/services/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final isValid = await authProvider.isTokenValid();
    
    if (!isValid) {
      // Clear all data if token is invalid
      await SharedPrefService.removeToken();
      await SharedPrefService.clearUserData();
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      }
      return;
    }

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Icon(
              Icons.chat_bubble_outline,
              size: 100,
              color: Theme.of(context).primaryColor,
            )
                .animate()
                .scale(duration: 500.ms, curve: Curves.easeOut)
                .then(delay: 300.ms)
                .fade(duration: 500.ms),

            const SizedBox(height: 24),

            // App name
            Text(
              "Secure Chat",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            )
                .animate(delay: 300.ms)
                .fade(duration: 500.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: 48),

            // Loading indicator
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ).animate(delay: 600.ms).fade(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
