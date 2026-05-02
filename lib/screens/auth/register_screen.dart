import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _obscurePassword = true;
  String? _profileImagePath;

  final List<Map<String, String>> _countries = [
    {'flag': '🇺🇸', 'name': 'United States'},
    {'flag': '🇪🇬', 'name': 'Egypt'},
    {'flag': '🇬🇧', 'name': 'United Kingdom'},
    {'flag': '🇩🇪', 'name': 'Germany'},
    {'flag': '🇫🇷', 'name': 'France'},
    {'flag': '🇸🇦', 'name': 'Saudi Arabia'},
    {'flag': '🇦🇪', 'name': 'UAE'},
  ];
  String _selectedCountry = 'United States';
  String _selectedFlag = '🇺🇸';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _profileImagePath = picked.path);
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim().isEmpty
        ? _selectedCountry
        : _addressController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      address: address,
      profileImagePath: _profileImagePath,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A12),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Register',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text('Join Amun Guide',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              'Create an account to start your premium\nEgyptian journey.',
              style: TextStyle(color: Colors.white60, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 32),

            // Profile image picker
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A1E),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFC5A358), width: 2),
                  ),
                  child: _profileImagePath != null
                      ? ClipOval(
                          child: Image.asset(_profileImagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.person, color: Colors.white54, size: 36)))
                      : const Icon(Icons.add_a_photo_outlined,
                          color: Color(0xFFC5A358), size: 28),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text('Add photo (optional)',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
            ),
            const SizedBox(height: 24),

            _label('Full Name'),
            const SizedBox(height: 10),
            _buildTextField(controller: _nameController, hint: 'John Doe'),

            const SizedBox(height: 20),
            _label('Email'),
            const SizedBox(height: 10),
            _buildTextField(
                controller: _emailController,
                hint: 'john@example.com',
                keyboardType: TextInputType.emailAddress),

            const SizedBox(height: 20),
            _label('Phone'),
            const SizedBox(height: 10),
            _buildTextField(
                controller: _phoneController,
                hint: '01012345678',
                keyboardType: TextInputType.phone),

            const SizedBox(height: 20),
            _label('Address (optional)'),
            const SizedBox(height: 10),
            _buildTextField(controller: _addressController, hint: 'Cairo, Egypt'),

            const SizedBox(height: 20),
            _label('Password'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A1E),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle:
                      const TextStyle(color: Colors.white38, fontSize: 15),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white38),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),
            _label('Country/Region'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _showCountryPicker(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A1E),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Text(_selectedFlag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(_selectedCountry,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15))),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC5A358),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.black, strokeWidth: 2))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Create Account',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'Already have an account? ',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 14)),
                      TextSpan(
                          text: 'Login',
                          style: TextStyle(
                              color: Color(0xFFC5A358),
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A1E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
              child: Text('Select Country',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold))),
          const SizedBox(height: 16),
          ..._countries.map((c) => ListTile(
                leading:
                    Text(c['flag']!, style: const TextStyle(fontSize: 24)),
                title: Text(c['name']!,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    _selectedCountry = c['name']!;
                    _selectedFlag = c['flag']!;
                  });
                  Navigator.pop(ctx);
                },
              )),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500));

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF2A2A1E),
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}

