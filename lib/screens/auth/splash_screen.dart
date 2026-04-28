import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amin_gide/features/auth/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _checkAuthStatus();
    });
  }

  void _checkAuthStatus() {
    final authProvider = context.read<AuthProvider>();

    if (authProvider.isAuthenticated) {
      // User already logged in
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User not logged in
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: const Icon(
                Icons.home_work_outlined,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Amun Guide',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
