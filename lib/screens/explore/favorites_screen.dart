// 📁 lib/screens/explore/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/place_card.dart';
import '../../core/widgets/section_header.dart';
import '../../features/places/providers/place_provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isGrid = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PlaceProvider>(context, listen: false);
      provider.loadFavorites();
    });
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
                const Text('My Favorites',
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

              Consumer<PlaceProvider>(
                builder: (_, provider, __) {
                  final count = provider.favorites.length;
                  return SectionHeader(title: '$count Places Saved');
                },
              ),
            ]),
          ),

          const SizedBox(height: 20),

          // ─── Results ────────────────────────────
          Expanded(
            child: Consumer<PlaceProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final favorites = provider.favorites;

                if (favorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          color: Colors.white24,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Favorites Yet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add places to your favorites to save them here',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/explore'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Explore Places',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
                      itemCount: favorites.length,
                      itemBuilder: (_, i) => PlaceCard(
                        image: favorites[i].imageUrl,
                        name: favorites[i].name,
                        location: favorites[i].location,
                        rating: favorites[i].rating.toString(),
                        price: '\$${favorites[i].price}/pax',
                        category: 'Saved',
                        style: PlaceCardStyle.grid,
                        isSaved: true,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/place-details',
                          arguments: {'placeId': favorites[i].id},
                        ),
                        onSave: () => provider.removeFromFavorites(favorites[i].id),
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: favorites.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => PlaceCard(
                        image: favorites[i].imageUrl,
                        name: favorites[i].name,
                        location: favorites[i].location,
                        rating: favorites[i].rating.toString(),
                        price: '\$${favorites[i].price}/pax',
                        category: 'Saved',
                        style: PlaceCardStyle.list,
                        isSaved: true,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/place-details',
                          arguments: {'placeId': favorites[i].id},
                        ),
                        onSave: () => provider.removeFromFavorites(favorites[i].id),
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
    super.dispose();
  }
}
