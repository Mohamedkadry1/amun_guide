// 📁 lib/screens/tourist/edit_profile_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../core/widgets/amun_button.dart';
import '../../core/widgets/amun_input.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name    = TextEditingController(text: 'Sarah Ahmed');
  final _email   = TextEditingController(text: 'sarah.ahmed@email.com');
  final _phone   = TextEditingController(text: '+20 100 123 4567');
  String _country = 'Egypt';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const AmunAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [

          // Avatar
          Center(
            child: Stack(children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 2.5),
                ),
                child: ClipOval(
                  child: Image.asset(AppAssets.sarah, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.person, color: Colors.white54, size: 50)),
                ),
              ),
              Positioned(bottom: 0, right: 0,
                child: Container(
                  width: 28, height: 28,
                  decoration: const BoxDecoration(
                      color: AppColors.gold, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.black, size: 14),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 32),

          AmunInput(controller: _name, hint: 'Full Name',
              prefixIcon: Icons.person_outline),
          const SizedBox(height: 14),

          AmunInput(controller: _email, hint: 'Email Address',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 14),

          AmunInput(controller: _phone, hint: 'Phone Number',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 14),

          // Country
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.bgInput,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(children: [
              const Icon(Icons.flag_outlined, color: Colors.white38, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(_country,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
              const Icon(Icons.keyboard_arrow_down,
                  color: Colors.white38),
            ]),
          ),

          const SizedBox(height: 32),

          AmunButton(
            label: 'Save Changes',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: AppColors.gold,
                ),
              );
              Navigator.pop(context);
            },
            icon: Icons.check,
          ),
        ]),
      ),
    );
  }
}