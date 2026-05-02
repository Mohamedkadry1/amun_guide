// 📁 lib/screens/tourist/saved_places_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../core/widgets/amun_button.dart';
import '../../data/models/place_model.dart';
import '../../providers/place_provider.dart';

class SavedPlacesScreen extends StatefulWidget {
  const SavedPlacesScreen({super.key});

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceProvider>().loadLikedPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PlaceProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const AmunAppBar(title: 'Saved Places', showBack: false),
      body: prov.isLoading && prov.likedPlaces.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : prov.likedPlaces.isEmpty
              ? _buildEmpty(context)
              : _buildGrid(context, prov.likedPlaces),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bookmark_outline, color: Colors.white24, size: 100),
            const SizedBox(height: 24),
            const Text('No saved treasures yet',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Start exploring and save your\nfavorite places here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 14, height: 1.6)),
            const SizedBox(height: 32),
            AmunButton(
              label: 'Explore Places',
              onTap: () => Navigator.pushNamed(context, '/explore'),
              icon: Icons.explore_outlined,
              fullWidth: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<PlaceModel> places) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemCount: places.length,
      itemBuilder: (_, i) => _PlaceCard(
        place: places[i],
        onTap: () => Navigator.pushNamed(context, '/place-details',
            arguments: places[i]),
        onUnsave: () {
          final prov = context.read<PlaceProvider>();
          prov.toggleLike(places[i].id).then((_) => prov.loadLikedPlaces());
        },
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  const _PlaceCard({
    required this.place,
    required this.onTap,
    required this.onUnsave,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: place.image != null
                      ? Image.network(place.image!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder())
                      : _placeholder(),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onUnsave,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bookmark,
                        color: AppColors.gold, size: 16),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Icon(Icons.star, color: AppColors.gold, size: 12),
                        const SizedBox(width: 3),
                        Text(place.displayRating,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 11)),
                      ]),
                      Text(place.displayPrice,
                          style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFF2A1A0A),
        child: const Icon(Icons.image, color: Colors.white24, size: 40),
      );
}

