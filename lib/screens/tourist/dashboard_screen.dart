// 📁 lib/screens/tourist/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/services/dio_client.dart';
import '../../core/services/tours_service.dart';
import '../../core/widgets/tour_card.dart';
import '../../core/widgets/hotel_card.dart';
import '../../core/widgets/section_header.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onExplore;
  const DashboardScreen({super.key, this.onExplore});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _userName = 'Explorer';
  String _userImage = '';
  List<Map<String, dynamic>> _tours = [];
  bool _isLoadingTours = true;
  final _toursService = ToursService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTours();
  }

  Future<void> _loadUserData() async {
    final data = await DioClient.getUserData();
    if (mounted) {
      setState(() {
        _userName = data['name']?.toString().split(' ').first ?? 'Explorer';
        _userImage = data['profile_image'] ?? '';
      });
    }
  }

  Future<void> _loadTours() async {
    try {
      final response = await _toursService.getPopularTours();
      final data = response.data;
      final List items = data['data'] ?? data ?? [];
      if (mounted) {
        setState(() {
          _tours = items
              .take(5)
              .map<Map<String, dynamic>>(
                (t) => {
                  'id': t['id'],
                  'img': t['image'] ?? t['image_url'] ?? '',
                  'name': t['title'] ?? t['name'] ?? '',
                  'loc': t['location'] ?? '',
                  'rating': (t['rating'] ?? 0).toString(),
                  'price': '\$${t['price'] ?? 0}/pax',
                  'tag': '${t['duration_days'] ?? 1}D',
                },
              )
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading tours: $e');
    } finally {
      if (mounted) setState(() => _isLoadingTours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _buildUpcomingTrip(),
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
                  title: 'Hotels for you',
                  actionLabel: 'See all',
                  onAction: widget.onExplore,
                ),
                const SizedBox(height: 14),
                HotelCard(
                  image: AppAssets.hotel1,
                  name: 'Marriott Mena House',
                  location: 'Giza, Egypt',
                  stars: 5,
                  price: '\$320/night',
                  onTap: () => Navigator.pushNamed(context, '/place-details'),
                ),
                const SizedBox(height: 12),
                HotelCard(
                  image: AppAssets.hotel2,
                  name: 'Winter Palace Luxor',
                  location: 'Luxor, Egypt',
                  stars: 5,
                  price: '\$280/night',
                  onTap: () => Navigator.pushNamed(context, '/place-details'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                    'Hi, $_userName! 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.stars, color: AppColors.gold, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '2,000 points',
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
                    child:
                        _userImage.isNotEmpty && _userImage.startsWith('http')
                        ? Image.network(
                            _userImage,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.person, color: Colors.white54),
                          )
                        : Image.asset(
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
              child: Row(
                children: const [
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

  Widget _buildUpcomingTrip() {
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
                child: const Text(
                  'Upcoming',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                '12 October 2024',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _flightPoint('CAI', '08:00'),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      '3h 30m',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Divider(color: Colors.white12),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.flight,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Nonstop',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
              _flightPoint('LXR', '11:30'),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white10),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Booking ID',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              Text(
                'AMG-7832',
                style: TextStyle(
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

  Widget _flightPoint(String code, String time) => Column(
    children: [
      Text(
        code,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
    ],
  );

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
                        color: AppColors.gold.withOpacity(0.3),
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

  Widget _buildToursRow(BuildContext context) {
    if (_isLoadingTours) {
      return const SizedBox(
        height: 210,
        child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      );
    }

    // Use API data if available, otherwise fallback to static data
    final tours = _tours.isNotEmpty
        ? _tours
        : [
            {
              'img': AppAssets.pyramids,
              'name': 'Giza Pyramids',
              'loc': 'Cairo',
              'rating': '4.9',
              'price': '\$150/pax',
              'tag': '1D',
            },
            {
              'img': AppAssets.karnak,
              'name': 'Karnak Temple',
              'loc': 'Luxor',
              'rating': '4.8',
              'price': '\$250/pax',
              'tag': '3D2N',
            },
            {
              'img': AppAssets.abuSimbel,
              'name': 'Abu Simbel',
              'loc': 'Aswan',
              'rating': '4.8',
              'price': '\$200/pax',
              'tag': '2D1N',
            },
          ];

    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tours.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => TourCard(
          image: tours[i]['img']?.toString() ?? '',
          name: tours[i]['name']?.toString() ?? '',
          location: tours[i]['loc']?.toString() ?? '',
          rating: tours[i]['rating']?.toString() ?? '',
          price: tours[i]['price']?.toString() ?? '',
          tag: tours[i]['tag']?.toString() ?? '',
          onTap: () => Navigator.pushNamed(
            context,
            '/tour-details',
            arguments: tours[i],
          ),
        ),
      ),
    );
  }
}
