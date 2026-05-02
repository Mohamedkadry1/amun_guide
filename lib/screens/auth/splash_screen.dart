// 📁 lib/screens/auth/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    final hasToken = await auth.tryAutoLogin();

    if (!mounted) return;
    if (hasToken) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              AppAssets.logo,
              height: 80,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.account_balance,
                color: Colors.white,
                size: 80,
              ),
            ),
            const SizedBox(height: 20),

            // App Name
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 38, color: Colors.white),
                children: [
                  TextSpan(text: 'Amun', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Guide', style: TextStyle(fontWeight: FontWeight.w300)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Your Passport to Ancient Adventures!',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
