// 📁 lib/screens/auth/onboarding_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/amun_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _current = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      image: AppAssets.onboarding1,
      title: 'Discover Ancient Egypt',
      subtitle: 'Explore thousands of years of history,\nfrom the Pyramids to hidden temples.',
    ),
    _OnboardingData(
      image: AppAssets.onboarding2,
      title: 'Plan Your Journey',
      subtitle: 'Let our AI build your perfect itinerary\nbased on your interests and time.',
    ),
    _OnboardingData(
      image: AppAssets.onboarding3,
      title: 'Travel with Confidence',
      subtitle: 'Book tours, guides, and hotels\nall in one place — safely.',
    ),
  ];

  void _next() {
    if (_current < _pages.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // Pages
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _pages.length,
            itemBuilder: (ctx, i) => _buildPage(_pages[i]),
          ),

          // Bottom controls
          Positioned(
            bottom: 48, left: 24, right: 24,
            child: Column(
              children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                        (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _current == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _current == i
                            ? AppColors.gold
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Button
                AmunButton(
                  label: _current == _pages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onTap: _next,
                  icon: _current == _pages.length - 1
                      ? Icons.flight_takeoff
                      : Icons.arrow_forward,
                ),

                const SizedBox(height: 16),

                // Skip
                if (_current < _pages.length - 1)
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/welcome'),
                    child: const Text('Skip',
                        style: TextStyle(
                            color: Colors.white38, fontSize: 14)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingData data) {
    return Column(
      children: [
        // Image — top 55%
        Expanded(
          flex: 55,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                data.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.bgCard,
                  child: const Icon(Icons.image,
                      color: Colors.white24, size: 80),
                ),
              ),
              // gradient bottom
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, AppColors.bgDark],
                    stops: [0.6, 1.0],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Text — bottom 45%
        Expanded(
          flex: 45,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                Text(data.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 15,
                        height: 1.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingData {
  final String image, title, subtitle;
  const _OnboardingData(
      {required this.image, required this.title, required this.subtitle});
}