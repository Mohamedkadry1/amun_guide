// 📁 lib/screens/explore/place_details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/place_model.dart';
import '../../providers/place_provider.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  bool _isSaved = false;
  bool _isExpanded = false;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final place = ModalRoute.of(context)!.settings.arguments as PlaceModel;
      context.read<PlaceProvider>().loadComments(place.id);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context)!.settings.arguments as PlaceModel;
    final placeProv = context.watch<PlaceProvider>();

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
                // زرار الرجوع
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
                // أزرار share و bookmark
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
                    onTap: () => setState(() => _isSaved = !_isSaved),
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
                      // صورة المكان
                      place.image != null
                          ? Image.network(
                              place.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            )
                          : _placeholder(),
                      // gradient في الأسفل
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
                      place.title,
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
                      children: const [
                        Icon(Icons.location_on, color: AppColors.gold, size: 16),
                        SizedBox(width: 4),
                        Text('Egypt', style: TextStyle(color: Colors.white54, fontSize: 13)),
                        SizedBox(width: 8),
                        Text('•', style: TextStyle(color: Colors.white24)),
                        SizedBox(width: 8),
                        Text('Historical Site', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // التقييم بالنجوم
                    Row(
                      children: [
                        // نجوم
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < place.rating.floor() ? Icons.star : (i < place.rating ? Icons.star_half : Icons.star_border),
                            color: AppColors.gold,
                            size: 18,
                          )),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          place.displayRating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '(Verified Review)',
                          style: TextStyle(color: Colors.white38, fontSize: 13),
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
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.15),
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
                          // Best time
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 15, height: 1.4),
                              children: [
                                TextSpan(
                                  text: 'Best time to visit:',
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
                        itemCount: 4,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) {
                          final imgs = [
                            'assets/images/karnak.jpg',
                            'assets/images/nile_sunset.jpg',
                            'assets/images/luxor_night.jpg',
                            'assets/images/valley.jpg',
                          ];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(
                              width: 160,
                              height: 130,
                              child: Image.asset(
                                imgs[i],
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
                    _buildReviewsSection(placeProv),

                    const SizedBox(height: 24),

                    // ── Nearby Attractions ──────────────────
                    const Text(
                      'Nearby Attractions',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          final nearby = [
                            {'img': 'assets/images/luxor_museum.jpg', 'name': 'Luxor Museum', 'dist': '2.5 km away', 'rating': '4.6'},
                            {'img': 'assets/images/colossi.jpg',      'name': 'Colossi of Memnon', 'dist': '4.1 km away', 'rating': '4.5'},
                            {'img': 'assets/images/valley.jpg',       'name': 'Valley of Kings', 'dist': '8.3 km away', 'rating': '4.8'},
                          ];
                          return _buildNearbyCard(
                            img: nearby[i]['img']!,
                            name: nearby[i]['name']!,
                            dist: nearby[i]['dist']!,
                            rating: nearby[i]['rating']!,
                          );
                        },
                      ),
                    ),
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
                  // Ask AI
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/ai-chat'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.5)),
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
                  // Add to Plan
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
  }

  Widget _placeholder() => Container(
        color: const Color(0xFF2A1F0E),
        child: const Icon(Icons.image, color: Colors.white24, size: 80),
      );

  // ── Reviews Section ────────────────────────────────────
  Widget _buildReviewsSection(PlaceProvider prov) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${prov.comments.length} comments',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),
          
          // Add Comment Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  if (_commentController.text.trim().isEmpty) return;
                  final place = ModalRoute.of(context)!.settings.arguments as PlaceModel;
                  prov.addComment(place.id, _commentController.text.trim());
                  _commentController.clear();
                },
                icon: const Icon(Icons.send, color: AppColors.gold),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (prov.isLoading)
            const Center(child: CircularProgressIndicator(color: AppColors.gold))
          else if (prov.comments.isEmpty)
            const Center(
              child: Text('No comments yet', style: TextStyle(color: Colors.white24)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prov.comments.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 24),
              itemBuilder: (_, i) {
                final comment = prov.comments[i];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.gold.withValues(alpha: 0.1),
                      backgroundImage: comment.userImage != null ? NetworkImage(comment.userImage!) : null,
                      child: comment.userImage == null ? const Icon(Icons.person, color: AppColors.gold, size: 18) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.userName ?? 'User',
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.content,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
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
                child: Image.asset(
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
}
