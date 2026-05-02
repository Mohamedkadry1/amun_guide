// 📁 lib/screens/admin/manage_tours_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../core/widgets/amun_filter_chip.dart';
import '../../providers/admin_provider.dart';
import '../../data/models/tour_model.dart';

class ManageToursScreen extends StatefulWidget {
  const ManageToursScreen({super.key});

  @override
  State<ManageToursScreen> createState() => _ManageToursScreenState();
}

class _ManageToursScreenState extends State<ManageToursScreen> {
  int _activeFilter = 0;
  final _filters = ['All', 'Active', 'Draft', 'Archived'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadTours();
    });
  }

  List<TourModel> _getFiltered(List<TourModel> tours) {
    if (_activeFilter == 0) return tours;
    // For now, let's assume status might be missing or different in API
    // We'll just filter by 'active' if selected
    if (_activeFilter == 1) return tours; 
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AdminProvider>();
    final filtered = _getFiltered(prov.tours);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AmunAppBar(
        title: 'Manage Tours',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.gold),
            onPressed: () => Navigator.pushNamed(context, '/create-tour'),
          ),
        ],
      ),
      body: Column(children: [
        // ─── Filters ────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_filters.length, (i) => AmunFilterChip(
                label: _filters[i],
                isActive: _activeFilter == i,
                onTap: () => setState(() => _activeFilter = i),
              )),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ─── List ────────────────────────────────
        Expanded(
          child: prov.isLoading && prov.tours.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : filtered.isEmpty
                ? const Center(child: Text('No tours found', style: TextStyle(color: Colors.white38)))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _tourCard(filtered[i], context),
                  ),
        ),
      ]),
    );
  }

  Widget _tourCard(TourModel t, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(
            height: 120, width: double.infinity,
            child: t.coverImage != null
              ? Image.network(t.coverImage!, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder())
              : _placeholder(),
          ),
        ),

        // Info
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(t.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                  Text(t.displayPrice,
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ],
              ),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.location_on_outlined, color: Colors.white38, size: 13),
                const SizedBox(width: 3),
                Text(t.location, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ]),
              const SizedBox(height: 12),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 12),

              // Actions
              Row(children: [
                _actionBtn(Icons.edit_outlined, 'Edit', Colors.blueAccent, () {}),
                const SizedBox(width: 8),
                _actionBtn(Icons.delete_outline, 'Delete', Colors.red, () => _confirmDelete(context, t)),
              ]),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _placeholder() => Container(
    color: AppColors.bgInput,
    child: const Icon(Icons.image, color: Colors.white24, size: 40),
  );

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TourModel t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: const Text('Delete Tour', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${t.title}"?', style: const TextStyle(color: Colors.white54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () {
              // TODO: context.read<AdminProvider>().deleteTour(t.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
