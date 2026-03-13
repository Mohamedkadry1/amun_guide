// 📁 lib/screens/admin/create_new_tour_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../core/widgets/amun_button.dart';
import '../../core/widgets/amun_input.dart';

class CreateNewTourScreen extends StatefulWidget {
  const CreateNewTourScreen({super.key});

  @override
  State<CreateNewTourScreen> createState() => _CreateNewTourScreenState();
}

class _CreateNewTourScreenState extends State<CreateNewTourScreen> {
  final _nameController      = TextEditingController();
  final _locationController  = TextEditingController();
  final _priceController     = TextEditingController();
  final _descController      = TextEditingController();
  final _maxPaxController    = TextEditingController();

  String _selectedCategory = 'Temples';
  int    _selectedDays     = 1;
  bool   _includeHotel     = true;
  bool   _includeTransport = true;
  bool   _includeMeals     = false;
  bool   _includeGuide     = true;

  final _categories = ['Temples', 'Deserts', 'Nile', 'Beaches', 'Museums', 'Adventure'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const AmunAppBar(title: 'Create New Tour'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ─── Upload Cover Image ────────────────
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.gold.withOpacity(0.3),
                    style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: const BoxDecoration(
                        color: AppColors.goldDim, shape: BoxShape.circle),
                    child: const Icon(Icons.add_photo_alternate_outlined,
                        color: AppColors.gold, size: 24),
                  ),
                  const SizedBox(height: 10),
                  const Text('Upload Cover Image',
                      style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('JPG, PNG up to 10MB',
                      style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ─── Basic Info ────────────────────────
          _sectionTitle('Basic Info'),
          const SizedBox(height: 12),

          AmunInput(
            controller: _nameController,
            hint: 'Tour name',
            label: 'Tour Name',
            prefixIcon: Icons.tour_outlined,
          ),
          const SizedBox(height: 14),

          AmunInput(
            controller: _locationController,
            hint: 'e.g. Luxor, Egypt',
            label: 'Location',
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 14),

          // Category picker
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Category',
                style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) => GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedCategory == cat
                          ? AppColors.gold
                          : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _selectedCategory == cat
                            ? AppColors.gold
                            : Colors.white12,
                      ),
                    ),
                    child: Text(cat,
                        style: TextStyle(
                            color: _selectedCategory == cat
                                ? Colors.black
                                : Colors.white54,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                )).toList(),
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // ─── Duration ──────────────────────────
          _sectionTitle('Duration'),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number of Days',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                Row(children: [
                  _counterBtn(Icons.remove, () {
                    if (_selectedDays > 1)
                      setState(() => _selectedDays--);
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('$_selectedDays',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                  _counterBtn(Icons.add, () {
                    if (_selectedDays < 30)
                      setState(() => _selectedDays++);
                  }),
                ]),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ─── Pricing & Capacity ────────────────
          _sectionTitle('Pricing & Capacity'),
          const SizedBox(height: 12),

          Row(children: [
            Expanded(
              child: AmunInput(
                controller: _priceController,
                hint: '0.00',
                label: 'Price per person (\$)',
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AmunInput(
                controller: _maxPaxController,
                hint: '12',
                label: 'Max Participants',
                prefixIcon: Icons.people_outline,
                keyboardType: TextInputType.number,
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // ─── Includes ──────────────────────────
          _sectionTitle('What\'s Included'),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(children: [
              _includeToggle('🏨 Hotel Accommodation', _includeHotel,
                      (v) => setState(() => _includeHotel = v)),
              const Divider(color: Colors.white10, height: 20),
              _includeToggle('🚌 Transport', _includeTransport,
                      (v) => setState(() => _includeTransport = v)),
              const Divider(color: Colors.white10, height: 20),
              _includeToggle('🥗 Meals', _includeMeals,
                      (v) => setState(() => _includeMeals = v)),
              const Divider(color: Colors.white10, height: 20),
              _includeToggle('🧑‍🏫 Licensed Guide', _includeGuide,
                      (v) => setState(() => _includeGuide = v)),
            ]),
          ),

          const SizedBox(height: 24),

          // ─── Description ───────────────────────
          _sectionTitle('Description'),
          const SizedBox(height: 12),

          AmunInput(
            controller: _descController,
            hint: 'Describe the tour experience...',
            label: 'Tour Description',
          ),
        ]),
      ),

      // ─── Bottom Bar ─────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1A16),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(children: [
          Expanded(
            child: AmunButton(
              label: 'Save as Draft',
              onTap: () => Navigator.pop(context),
              variant: AmunButtonVariant.outlined,
              icon: Icons.save_outlined,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AmunButton(
              label: 'Publish Tour',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tour published successfully! 🎉'),
                    backgroundColor: AppColors.gold,
                  ),
                );
                Navigator.pop(context);
              },
              icon: Icons.publish_outlined,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(title,
      style: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold));

  Widget _counterBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        color: AppColors.bgInput,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white12),
      ),
      child: Icon(icon, color: AppColors.gold, size: 16),
    ),
  );

  Widget _includeToggle(
      String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 14)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.gold,
        ),
      ],
    );
  }
}