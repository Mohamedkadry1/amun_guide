// 📁 lib/screens/auth/reset_password_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_button.dart';
import '../../core/widgets/amun_input.dart';
import '../../core/widgets/amun_app_bar.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final _newPassword     = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const AmunAppBar(title: 'New Password'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Center(
              child: Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline,
                    color: AppColors.gold, size: 44),
              ),
            ),

            const SizedBox(height: 32),

            const Text('Create New Password',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              'Your new password must be different from previously used passwords.',
              style: TextStyle(
                  color: Colors.white54, fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 32),

            AmunInput(
              controller: _newPassword,
              hint: 'New Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 14),

            AmunInput(
              controller: _confirmPassword,
              hint: 'Confirm Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 28),

            AmunButton(
              label: 'Reset Password',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }
}