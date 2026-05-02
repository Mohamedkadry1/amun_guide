// 📁 lib/screens/explore/tour_details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/tour_model.dart';
import '../../providers/booking_provider.dart';

class TourDetailsScreen extends StatefulWidget {
  const TourDetailsScreen({super.key});

  @override
  State<TourDetailsScreen> createState() => _TourDetailsScreenState();
}

class _TourDetailsScreenState extends State<TourDetailsScreen> {
  bool _isSaved = false;
  int _participants = 1;

  @override
  Widget build(BuildContext context) {
    final tour = ModalRoute.of(context)!.settings.arguments as TourModel;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1208),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero Image ──────────────────────────────────
              SliverAppBar(
                expandedHeight: 260,
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
                    onTap: () => setState(() => _isSaved = !_isSaved),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isSaved ? Icons.favorite : Icons.favorite_border,
                        color: _isSaved ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      tour.coverImage != null
                          ? Image.network(
                              tour.coverImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            )
                          : _placeholder(),
                      // Gradient
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xFF1A1208)],
                            stops: [0.4, 1.0],
                          ),
                        ),
                      ),
                      // Premium Badge
                      Positioned(
                        bottom: 16, left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Premium Choice',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.verified, color: Colors.black, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Content ─────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    // ── Title and Price ──────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            tour.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              tour.displayPrice,
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'per person',
                              style: TextStyle(color: Colors.white38, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.gold, size: 15),
                        const SizedBox(width: 4),
                        Text(
                          tour.location,
                          style: const TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Rating
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < (tour.rating ?? 0).floor() ? Icons.star : Icons.star_border,
                            color: AppColors.gold,
                            size: 18,
                          )),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tour.displayRating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Verified Tour',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),

                    const SizedBox(height: 6),
                    const Divider(color: Colors.white10, height: 30),

                    // ── Your Guide ──────────────────────────
                    const Text(
                      'Your Guide',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildGuideCard(),

                    const SizedBox(height: 24),

                    // ── About the Tour ──────────────────────
                    const Text(
                      'About the Tour',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tour.details ?? 'No details available for this tour.',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Places Included ─────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Places Included',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'View Map',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...tour.places.map((place) => _buildPlaceItem(place)),

                    const SizedBox(height: 24),
                    const Text(
                      'Select Participants',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _participantBtn(Icons.remove, () {
                          if (_participants > 1) setState(() => _participants--);
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '$_participants',
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _participantBtn(Icons.add, () {
                          setState(() => _participants++);
                        }),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),

          // ── Bottom Bar ─────────────────────────────────────
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
                  // Upload Receipt
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/payment-receipts'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.upload_file, color: AppColors.gold, size: 18),
                      label: const Text(
                        'Upload Receipt',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Join Tour
                  Expanded(
                    child: Consumer<BookingProvider>(
                      builder: (context, prov, _) => ElevatedButton(
                        onPressed: prov.isLoading ? null : () async {
                          final nav = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);
                          final ok = await prov.bookTour(tour.id, _participants);
                          if (!mounted) return;
                          if (ok) {
                            nav.pushNamed('/payment-success');
                          } else {
                            messenger.showSnackBar(
                              SnackBar(content: Text(prov.error ?? 'Booking failed')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: prov.isLoading 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                          : const Text(
                              'Join Tour',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
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

  Widget _participantBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: AppColors.gold, size: 20),
      ),
    );
  }

  // ── Guide Card ─────────────────────────────────────────
  Widget _buildGuideCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Guide Image
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: ClipOval(
              child: Container(
                color: const Color(0xFFE8D5A3),
                child: const Icon(Icons.person, color: Colors.brown, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Guide Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '5.0',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.star, color: AppColors.gold, size: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Certified Egyptologist',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Expert in Ancient History',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Message Button
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  // ── Place Item ─────────────────────────────────────────
  Widget _buildPlaceItem(dynamic place) {
    final title = place is Map ? place['title'] : 'Place';
    final image = place is Map ? place['image'] : null;

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            // Place Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 70, height: 70,
                child: image != null
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholderItem(),
                      )
                    : _placeholderItem(),
              ),
            ),
            const SizedBox(width: 14),
            // Name and Category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Historical Site',
                    style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _placeholderItem() => Container(
        color: const Color(0xFF2A1F0E),
        child: const Icon(Icons.image, color: Colors.white24),
      );
}
