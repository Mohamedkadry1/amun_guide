// 📁 lib/screens/payment/payment_failed_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_button.dart';

class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Spacer(),

              // ─── Error Icon ──────────────────────
              Container(
                width: 110, height: 110,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 3),
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.red, size: 60),
              ),

              const SizedBox(height: 32),

              const Text('Upload Failed!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),

              const SizedBox(height: 12),

              const Text(
                'Something went wrong while uploading\nyour receipt. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white54, fontSize: 15, height: 1.6),
              ),

              const SizedBox(height: 32),

              // ─── Possible Reasons ────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Possible reasons:',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(height: 12),
                    _reasonRow('File size exceeds 10MB'),
                    _reasonRow('Unsupported file format'),
                    _reasonRow('Poor internet connection'),
                    _reasonRow('Server temporarily unavailable'),
                  ],
                ),
              ),

              const Spacer(),

              // ─── Buttons ─────────────────────────
              AmunButton(
                label: 'Try Again',
                onTap: () => Navigator.pushReplacementNamed(
                    context, '/payment-receipts'),
                icon: Icons.refresh_outlined,
              ),

              const SizedBox(height: 12),

              AmunButton(
                label: 'Back to Dashboard',
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false),
                variant: AmunButtonVariant.outlined,
                icon: Icons.home_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reasonRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        const Icon(Icons.error_outline,
            color: Colors.red, size: 16),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(
                color: Colors.white54, fontSize: 13)),
      ]),
    );
  }
}