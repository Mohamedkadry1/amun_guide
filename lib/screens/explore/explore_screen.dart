// 📁 lib/screens/explore/explore_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/amun_filter_chip.dart';
import '../../core/widgets/place_card.dart';
import '../../core/widgets/section_header.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _activeFilter = 0;
  bool _isGrid = true;
  final _searchController = TextEditingController();

  final _filters = ['All', 'Temples', 'Deserts', 'Nile', 'Beaches', 'Museums'];

  final _places = [
    {'img': AppAssets.pyramids,   'name': 'Giza Pyramids',   'loc': 'Cairo, Egypt',      'rating': '4.9', 'price': '\$150/pax', 'cat': 'Temples'},
    {'img': AppAssets.karnak,     'name': 'Karnak Temple',   'loc': 'Luxor, Egypt',      'rating': '4.8', 'price': '\$250/pax', 'cat': 'Temples'},
    {'img': AppAssets.abuSimbel,  'name': 'Abu Simbel',      'loc': 'Aswan, Egypt',      'rating': '4.8', 'price': '\$200/pax', 'cat': 'Temples'},
    {'img': AppAssets.siwa,       'name': 'Siwa Oasis',      'loc': 'Siwa, Egypt',       'rating': '4.7', 'price': '\$180/pax', 'cat': 'Deserts'},
    {'img': AppAssets.nileSunset, 'name': 'Nile Cruise',     'loc': 'Luxor → Aswan',    'rating': '4.9', 'price': '\$350/pax', 'cat': 'Nile'},
    {'img': AppAssets.alexandria, 'name': 'Alexandria',      'loc': 'Alexandria, Egypt', 'rating': '4.6', 'price': '\$120/pax', 'cat': 'Beaches'},
    {'img': AppAssets.museum,     'name': 'Egyptian Museum', 'loc': 'Cairo, Egypt',      'rating': '4.7', 'price': '\$80/pax',  'cat': 'Museums'},
    {'img': AppAssets.valley,     'name': 'Valley of Kings', 'loc': 'Luxor, Egypt',      'rating': '4.8', 'price': '\$160/pax', 'cat': 'Temples'},
  ];

  List<Map<String, dynamic>> get _filtered => _activeFilter == 0
      ? _places
      : _places.where((p) => p['cat'] == _filters[_activeFilter]).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(children: [

          // ─── Header ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Explore Egypt',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                // Grid / List toggle
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(children: [
                    _toggleBtn(Icons.grid_view, true),
                    _toggleBtn(Icons.view_list, false),
                  ]),
                ),
              ]),

              const SizedBox(height: 14),

              // Search
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgInput,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(children: [
                  const Icon(Icons.search, color: Colors.white38, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Search places, tours...',
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.tune, color: Colors.black, size: 16),
                  ),
                ]),
              ),

              const SizedBox(height: 12),

              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (i) => AmunFilterChip(
                    label: _filters[i],
                    isActive: _activeFilter == i,
                    onTap: () => setState(() => _activeFilter = i),
                  )),
                ),
              ),

              const SizedBox(height: 14),

              SectionHeader(title: '${_filtered.length} Places Found'),
            ]),
          ),

          const SizedBox(height: 12),

          // ─── Results ────────────────────────────
          Expanded(
            child: _isGrid
                ? GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => PlaceCard(
                image: _filtered[i]['img'],
                name: _filtered[i]['name'],
                location: _filtered[i]['loc'],
                rating: _filtered[i]['rating'],
                price: _filtered[i]['price'],
                category: _filtered[i]['cat'],
                style: PlaceCardStyle.grid,
                onTap: () => Navigator.pushNamed(context, '/place-details'),
                onSave: () {},
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => PlaceCard(
                image: _filtered[i]['img'],
                name: _filtered[i]['name'],
                location: _filtered[i]['loc'],
                rating: _filtered[i]['rating'],
                price: _filtered[i]['price'],
                category: _filtered[i]['cat'],
                style: PlaceCardStyle.list,
                onTap: () => Navigator.pushNamed(context, '/place-details'),
                onSave: () {},
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _toggleBtn(IconData icon, bool isGrid) {
    final active = _isGrid == isGrid;
    return GestureDetector(
      onTap: () => setState(() => _isGrid = isGrid),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: active ? Colors.black : Colors.white38, size: 18),
      ),
    );
  }
}