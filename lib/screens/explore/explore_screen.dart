// 📁 lib/screens/explore/explore_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_filter_chip.dart';
import '../../core/widgets/place_card.dart';
import '../../core/widgets/section_header.dart';
import '../../features/places/providers/place_provider.dart';
import '../../features/places/models/place_models.dart';
import 'place_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _activeFilter = 0;
  bool _isGrid = true;
  final _searchController = TextEditingController();
  final List<String> _filters = [
    'All',
    'Temples',
    'Museums',
    'Nature',
    'Culture',
    'Historical'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PlaceProvider>(context, listen: false);
      provider.loadPlaces();
    });
  }

  void _onSearchChanged() {
    final provider = Provider.of<PlaceProvider>(context, listen: false);
    final query = _searchController.text;
    provider.loadPlaces(search: query.isNotEmpty ? query : null);
  }

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
                    onTap: () {
                      setState(() => _activeFilter = i);
                      final provider = Provider.of<PlaceProvider>(context, listen: false);
                      final query = _searchController.text;
                      final categoryId = i == 0 ? 0 : i;
                      provider.loadPlaces(search: query, categoryId: categoryId);
                    },
                  )),
                ),
              ),

              const SizedBox(height: 14),

              Consumer<PlaceProvider>(
                builder: (_, provider, __) {
                  final count = provider.places.length;
                  return SectionHeader(title: '$count Places Found');
                },
              ),
            ]),
          ),

          const SizedBox(height: 12),

          // ─── Results ────────────────────────────
          Expanded(
            child: Consumer<PlaceProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading && provider.places.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                // Use mock data if API fails or is empty
                final places = provider.places.isNotEmpty 
                    ? provider.places 
                    : _getMockPlaces();

                if (places.isEmpty) {
                  return const Center(
                    child: Text(
                      'No places found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return _isGrid
                    ? GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: places.length,
                      itemBuilder: (_, i) => PlaceCard(
                        image: places[i].imageUrl,
                        name: places[i].name,
                        location: places[i].location,
                        rating: places[i].rating.toString(),
                        price: '\$${places[i].price}/pax',
                        category: 'Temples',
                        style: PlaceCardStyle.grid,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceDetailsScreen(placeId: places[i].id),
                          ),
                        ),
                        onSave: () => provider.addToFavorites(places[i].id),
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: places.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => PlaceCard(
                        image: places[i].imageUrl,
                        name: places[i].name,
                        location: places[i].location,
                        rating: places[i].rating.toString(),
                        price: '\$${places[i].price}/pax',
                        category: 'Temples',
                        style: PlaceCardStyle.list,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceDetailsScreen(placeId: places[i].id),
                          ),
                        ),
                        onSave: () => provider.addToFavorites(places[i].id),
                      ),
                    );
              },
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Provide mock places data when API fails
  List<Place> _getMockPlaces() {
    return [
      Place(
        id: 1,
        name: 'Great Pyramids',
        location: 'Giza',
        description: 'The most iconic landmarks in Egypt',
        imageUrl: 'https://via.placeholder.com/400x300?text=Great+Pyramids',
        rating: 4.8,
        price: 50,
        reviewsCount: 328,
        latitude: 29.9792,
        longitude: 31.1342,
        categoryId: 1,
        createdAt: DateTime.now(),
      ),
      Place(
        id: 2,
        name: 'Egyptian Museum',
        location: 'Cairo',
        description: 'World-class collection of ancient artifacts',
        imageUrl: 'https://via.placeholder.com/400x300?text=Museum',
        rating: 4.6,
        price: 30,
        reviewsCount: 256,
        latitude: 30.0454,
        longitude: 31.2357,
        categoryId: 2,
        createdAt: DateTime.now(),
      ),
      Place(
        id: 3,
        name: 'Karnak Temple',
        location: 'Luxor',
        description: 'Ancient temple complex with stunning architecture',
        imageUrl: 'https://via.placeholder.com/400x300?text=Karnak+Temple',
        rating: 4.7,
        price: 40,
        reviewsCount: 412,
        latitude: 25.7176,
        longitude: 32.6563,
        categoryId: 1,
        createdAt: DateTime.now(),
      ),
      Place(
        id: 4,
        name: 'Valley of Kings',
        location: 'Luxor',
        description: 'Royal burial ground with magnificent tombs',
        imageUrl: 'https://via.placeholder.com/400x300?text=Valley+of+Kings',
        rating: 4.9,
        price: 45,
        reviewsCount: 501,
        latitude: 25.7404,
        longitude: 32.6011,
        categoryId: 1,
        createdAt: DateTime.now(),
      ),
    ];
  }
}