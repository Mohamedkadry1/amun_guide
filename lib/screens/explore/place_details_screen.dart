// 📁 lib/screens/explore/place_details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../features/places/providers/place_provider.dart';
import '../../features/places/models/place_models.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final int? placeId;
  
  const PlaceDetailsScreen({super.key, this.placeId});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  bool _isSaved = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.placeId != null) {
        Provider.of<PlaceProvider>(context, listen: false).loadPlaceDetails(widget.placeId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaceProvider>(
      builder: (_, provider, __) {
        final place = provider.selectedPlace ?? _getMockPlace();
        
        if (provider.isLoading && provider.selectedPlace == null) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A1208),
            body: const Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        if (place == null) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A1208),
            appBar: AppBar(backgroundColor: const Color(0xFF1A1208)),
            body: const Center(
              child: Text('Place not found', style: TextStyle(color: Colors.white)),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF1A1208),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // ── Hero Image ──────────────────────────────────
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: const Color(0xFF1A1208),
                    elevation: 0,
                    leading: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _isSaved = !_isSaved);
                          if (!_isSaved) {
                            provider.addToFavorites(place.id);
                          } else {
                            provider.removeFromFavorites(place.id);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isSaved ? Icons.bookmark : Icons.bookmark_outline,
                            color: _isSaved ? AppColors.gold : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            place.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF2A1F0E),
                              child: const Icon(Icons.image, color: Colors.white24, size: 80),
                            ),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Color(0xFF1A1208)],
                                stops: [0.5, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Content ─────────────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([

                        // ── الاسم والموقع والتقييم ──────────────
                        Text(
                          place.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // الموقع والنوع
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.gold, size: 16),
                            const SizedBox(width: 4),
                            Text(place.location, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: Colors.white24)),
                            const SizedBox(width: 8),
                            const Text('Historical Site', style: TextStyle(color: Colors.white54, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // التقييم بالنجوم
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (i) => Icon(
                                i < place.rating.toInt() ? Icons.star : Icons.star_half,
                                color: AppColors.gold,
                                size: 18,
                              )),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              place.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${place.reviewsCount} reviews)',
                              style: const TextStyle(color: Colors.white38, fontSize: 13),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── Amun AI Insight ─────────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF221A0A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.gold.withOpacity(0.35)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.gold.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.auto_awesome, color: AppColors.gold, size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Amun AI Insight',
                                    style: TextStyle(
                                      color: AppColors.gold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 15, height: 1.4),
                                  children: [
                                    TextSpan(
                                      text: 'Best time to visit: ',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    TextSpan(
                                      text: '8:00 AM',
                                      style: TextStyle(
                                        color: AppColors.gold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Early morning offers the best lighting for photos and avoids the midday heat and largest crowds.',
                                style: TextStyle(color: Colors.white38, fontSize: 13, height: 1.5),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── About ───────────────────────────────
                        const Text(
                          'About',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          place.description,
                          style: const TextStyle(color: Colors.white54, fontSize: 14, height: 1.7),
                          maxLines: _isExpanded ? null : 4,
                          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => setState(() => _isExpanded = !_isExpanded),
                          child: Row(
                            children: [
                              Text(
                                _isExpanded ? 'Show less' : 'Read more',
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _isExpanded ? Icons.arrow_upward : Icons.arrow_forward,
                                color: AppColors.gold,
                                size: 14,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Gallery ─────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Gallery',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'View All',
                                style: TextStyle(color: AppColors.gold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 130,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.selectedPlaceImages.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (_, i) {
                              final img = provider.selectedPlaceImages[i];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: SizedBox(
                                  width: 160,
                                  height: 130,
                                  child: Image.network(
                                    img.url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: const Color(0xFF2A1F0E),
                                      child: const Icon(Icons.image, color: Colors.white24),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Reviews ─────────────────────────────
                        _buildReviewsSection(place),

                        const SizedBox(height: 24),

                        // ── Nearby Attractions ──────────────────
                        const Text(
                          'Nearby Attractions',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        const SizedBox(height: 160),
                      ]),
                    ),
                  ),
                ],
              ),

              // ── Bottom Bar ────────────────────────────────────
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20, 14, 20, MediaQuery.of(context).padding.bottom + 14,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1208),
                    border: Border(top: BorderSide(color: Colors.white10)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/ai-chat'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.gold.withOpacity(0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text(
                            'Ask AI',
                            style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/tour-details'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Add to Plan',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Reviews Section ────────────────────────────────────
  Widget _buildReviewsSection(place) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF221A0A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // الرقم الكبير
              Column(
                children: [
                  Text(
                    place.rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (i) => Icon(
                      i < place.rating.toInt() ? Icons.star : Icons.star_half,
                      color: AppColors.gold,
                      size: 14,
                    )),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${place.reviewsCount} reviews',
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // شرائط التقييم
              Expanded(
                child: Column(
                  children: List.generate(5, (i) {
                    final vals = [0.85, 0.65, 0.3, 0.15, 0.05];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text('${5 - i}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: vals[i],
                                backgroundColor: Colors.white10,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                                minHeight: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Nearby Card ────────────────────────────────────────
  Widget _buildNearbyCard({
    required String img,
    required String name,
    required String dist,
    required String rating,
  }) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 150,
                height: 105,
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF2A1F0E),
                    child: const Icon(Icons.image, color: Colors.white24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dist, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 11),
                    const SizedBox(width: 2),
                    Text(rating, style: const TextStyle(color: AppColors.gold, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Provide mock place data when API fails
  Place _getMockPlace() {
    return Place(
      id: 1,
      name: 'Great Pyramids of Giza',
      location: 'Giza, Egypt',
      description: 'The Great Pyramids are the most iconic landmarks in Egypt and among the Seven Wonders of the Ancient World. Built during the Old Kingdom period, these magnificent structures served as elaborate tombs for Pharaohs.',
      imageUrl: 'https://via.placeholder.com/600x400?text=Great+Pyramids',
      rating: 4.8,
      price: 50,
      reviewsCount: 1250,
      latitude: 29.9792,
      longitude: 31.1342,
      categoryId: 1,
      createdAt: DateTime.now(),
    );
  }
}