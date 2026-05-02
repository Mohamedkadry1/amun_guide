// ============================================
// 📁 lib/screens/user_selection_screen.dart
// اختيار نوع المستخدم — بعدها يروح Home
// ============================================

import 'package:flutter/material.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  // الكارد المختار حالياً
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _userTypes = [
    {
      'icon': Icons.luggage,
      'title': 'Tourist',
      'desc': "I'm visiting Egypt for the first time",
    },
    {
      'icon': Icons.map_outlined,
      'title': 'Local Explorer',
      'desc': 'I live in Egypt and want to discover more',
    },
    {
      'icon': Icons.business_center_outlined,
      'title': 'Business Traveler',
      'desc': "I'm here for work but want to explore",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151411),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // أيقونة فوق
              const Icon(Icons.account_balance, color: Color(0xFFC5A358), size: 50),
              const SizedBox(height: 20),

              // العنوان
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Who Are ', style: TextStyle(color: Colors.white)),
                    TextSpan(text: 'You?', style: TextStyle(color: Color(0xFFC5A358))),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Choose your profile to get a personalized experience',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),

              const SizedBox(height: 32),

              // كروت الاختيار
              ...List.generate(_userTypes.length, (index) {
                final item = _userTypes[index];
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFC5A358).withValues(alpha: 0.1)
                          : const Color(0xFF2A241F),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFC5A358)
                            : Colors.white10,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(item['icon'],
                            color: isSelected ? const Color(0xFFC5A358) : Colors.white54,
                            size: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'],
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFFC5A358) : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                              const SizedBox(height: 4),
                              Text(item['desc'],
                                  style: const TextStyle(
                                      color: Colors.white38, fontSize: 12)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              color: Color(0xFFC5A358), size: 20),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // زرار Continue
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // روح الـ Home وامسح كل الشاشات السابقة
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC5A358),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Continue →',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
