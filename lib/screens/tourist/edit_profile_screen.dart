// 📁 lib/screens/tourist/edit_profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../core/widgets/amun_button.dart';
import '../../core/widgets/amun_input.dart';
import '../../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _phone;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _name = TextEditingController(text: user?.name);
    _email = TextEditingController(text: user?.email);
    _phone = TextEditingController(text: user?.phone);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _save() async {
    final prov = context.read<AuthProvider>();
    final ok = await prov.updateProfile(
      name: _name.text,
      email: _email.text,
      avatar: _imageFile,
    );
    
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: AppColors.gold),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(prov.errorMessage ?? 'Update failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const AmunAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // Avatar
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 2.5),
                  ),
                  child: ClipOval(
                    child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : (user?.profileImage != null
                          ? Image.network(user!.profileImage!, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder())
                          : _placeholder()),
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
          const SizedBox(height: 32),

          AmunButton(
            label: 'Save Changes',
            onTap: _save,
            isLoading: isLoading,
            icon: Icons.check,
          ),
        ]),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: AppColors.bgCard,
    child: const Icon(Icons.person, color: Colors.white54, size: 50),
  );
}
