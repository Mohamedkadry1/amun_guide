import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/amun_button.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/tour_model.dart';
import '../../data/models/place_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tour_provider.dart';
import '../../providers/place_provider.dart';
import '../../providers/booking_provider.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onExplore;
  const DashboardScreen({super.key, this.onExplore});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TourProvider>().loadPopular();
      context.read<PlaceProvider>().loadTrending();
      context.read<BookingProvider>().loadMyBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, user?.name)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _buildUpcomingTrip(context),
                const SizedBox(height: 28),
                _buildCategories(context),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Popular Tours',
                  actionLabel: 'See all',
                  onAction: widget.onExplore,
                ),
                const SizedBox(height: 14),
                _buildToursRow(context),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Trending Places',
                  actionLabel: 'See all',
                  onAction: widget.onExplore,
                ),
                const SizedBox(height: 14),
                _buildTrendingList(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String? name) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1A16),
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${name ?? 'Explorer'}! 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.stars, color: AppColors.gold, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Amun Guide',
                        style: TextStyle(color: AppColors.gold, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppAssets.sarah,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.white54),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: widget.onExplore,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.bgInput,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white38, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Where to go?',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTrip(BuildContext context) {
    final bookingProv = context.watch<BookingProvider>();
    if (bookingProv.isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    if (bookingProv.bookings.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.beach_access_outlined,
              color: Colors.white24,
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'No upcoming trips',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 12),
            AmunButton(
              label: 'Explore Tours',
              onTap: widget.onExplore ?? () {},
              variant: AmunButtonVariant.outlined,
              
            ),
          ],
        ),
      );
    }

    final b = bookingProv.bookings.first;
    final tour = b.tour;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  b.status.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                b.createdAt?.split('T').first ?? 'Upcoming',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tour?.title ?? 'Tour Booking',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.gold,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tour?.location ?? 'Egypt',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white10),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Participants',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              Text(
                '${b.participantsCount} Persons',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Booking ID',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              Text(
                'AMG-${b.id}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final cats = [
      [Icons.account_balance_outlined, 'Temples'],
      [Icons.landscape_outlined, 'Deserts'],
      [Icons.sailing_outlined, 'Nile'],
      [Icons.beach_access_outlined, 'Beaches'],
      [Icons.museum_outlined, 'Museums'],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Explore Egypt',
          actionLabel: 'See all',
          onAction: widget.onExplore,
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 82,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cats.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) => GestureDetector(
              onTap: widget.onExplore,
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.goldDim,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      cats[i][0] as IconData,
                      color: AppColors.gold,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cats[i][1] as String,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Popular Tours من الـ API
  Widget _buildToursRow(BuildContext context) {
    final tourProv = context.watch<TourProvider>();

    if (tourProv.isLoading) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    if (tourProv.popular.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(
          child: Text(
            'No tours available',
            style: TextStyle(color: Colors.white38),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tourProv.popular.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final tour = tourProv.popular[i];
          return _TourCard(
            tour: tour,
            onTap: () =>
                Navigator.pushNamed(context, '/tour-details', arguments: tour),
          );
        },
      ),
    );
  }

  // Trending Places من الـ API
  Widget _buildTrendingList(BuildContext context) {
    final placeProv = context.watch<PlaceProvider>();

    if (placeProv.isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    if (placeProv.trending.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'No places available',
            style: TextStyle(color: Colors.white38),
          ),
        ),
      );
    }

    return Column(
      children: placeProv.trending
          .take(3)
          .map(
            (p) => _PlaceListItem(
              place: p,
              onTap: () =>
                  Navigator.pushNamed(context, '/place-details', arguments: p),
            ),
          )
          .toList(),
    );
  }
}

// ── Tour card widget ────────────────────────────────────────────────────
class _TourCard extends StatelessWidget {
  final TourModel tour;
  final VoidCallback onTap;
  const _TourCard({required this.tour, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: tour.coverImage != null
                    ? Image.network(
                        tour.coverImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tour.displayPrice,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
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
    color: AppColors.goldDim,
    child: const Icon(Icons.image_outlined, color: AppColors.gold, size: 32),
  );
}

// ── Place list item ─────────────────────────────────────────────────────
class _PlaceListItem extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onTap;
  const _PlaceListItem({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 60,
                height: 60,
                child: place.image != null
                    ? Image.network(
                        place.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imgPlaceholder(),
                      )
                    : _imgPlaceholder(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        place.displayRating,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              place.displayPrice,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
    color: AppColors.goldDim,
    child: const Icon(Icons.place, color: AppColors.gold),
  );
}

