// ============================================
// 📁 lib/screens/auth/welcome_screen.dart
// ============================================

import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. الخلفية (صورة الأهرامات والنجوم)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // طبقة شفافة سودة عشان الكلام يبان
          Container(color: Colors.black.withValues(alpha: 0.3)),

          // 2. المحتوى فوق الخلفية
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // اللوجو من الـ assets
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Amun Guide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Experience Egypt like never\nbefore. Choose your path.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const Spacer(),

                // ── زرار Tourist
                _buildSelectionButton(
                  context,
                  label: 'Tourist',
                  icon: Icons.business_center,
                  color: const Color(0xFFE5B54F),
                  isDarkText: true,
                  onTap: () {
                    // ✅ Tourist → Login
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),

                const SizedBox(height: 15),

                // ── زرار Guide
                _buildSelectionButton(
                  context,
                  label: 'Guide',
                  icon: Icons.map,
                  color: Colors.white.withValues(alpha: 0.2),
                  isDarkText: false,
                  onTap: () {
                    // ✅ Guide → Login
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),

                const SizedBox(height: 40),

                // ── Admin Login
                GestureDetector(
                  onTap: () {
                    // ✅ Admin → Login مع argument
                    Navigator.pushNamed(context, '/login', arguments: 'admin');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Admin Login ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Icon(Icons.lock_outline, color: Colors.white, size: 16),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionButton(
      BuildContext context, {
        required String label,
        required IconData icon,
        required Color color,
        required bool isDarkText,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 75,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
          border: !isDarkText
              ? Border.all(color: Colors.white, width: 1)
              : null,
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 30,
              backgroundColor:
              isDarkText ? Colors.black.withValues(alpha: 0.8) : Colors.white,
              child: Icon(
                icon,
                color: isDarkText ? const Color(0xFFE5B54F) : Colors.black,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'I AM A',
                  style: TextStyle(
                    color: isDarkText ? Colors.black54 : Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: isDarkText ? Colors.black : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward,
              color: isDarkText ? Colors.black : Colors.white,
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
