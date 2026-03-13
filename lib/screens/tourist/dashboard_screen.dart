// 📁 lib/screens/tourist/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/tour_card.dart';
import '../../core/widgets/hotel_card.dart';
import '../../core/widgets/section_header.dart';

class DashboardScreen extends StatelessWidget {
  // ✅ أضفنا onExplore callback
  final VoidCallback? onExplore;
  const DashboardScreen({super.key, this.onExplore});

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
                  // ✅ بدل pushNamed('/explore') بقت onExplore
                  onAction: onExplore,
                ),
                const SizedBox(height: 14),
                _buildToursRow(context),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Hotels for you',
                  actionLabel: 'See all',
                  // ✅ نفس الشيء هنا
                  onAction: onExplore,
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
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Hi, Explorer! 👋',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Row(children: [
                Icon(Icons.stars, color: AppColors.gold, size: 14),
                SizedBox(width: 4),
                Text('2,000 points',
                    style: TextStyle(color: AppColors.gold, fontSize: 13)),
              ]),
            ]),
            GestureDetector(
              // ✅ Profile مش داخل MainNavigation فـ pushNamed صح هنا
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(AppAssets.sarah, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, color: Colors.white54)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // ✅ Search bar بيروح لـ Explore tab مش شاشة جديدة
        GestureDetector(
          onTap: onExplore,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.bgInput,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(children: const [
              Icon(Icons.search, color: Colors.white38, size: 20),
              SizedBox(width: 10),
              Text('Where to go?',
                  style: TextStyle(color: Colors.white38, fontSize: 14)),
            ]),
          ),
        ),
      ]),
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
      child: Column(children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(20)),
            child: const Text('Upcoming',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          const Text('12 October 2024',
              style: TextStyle(color: Colors.white38, fontSize: 12)),
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _flightPoint('CAI', '08:00'),
          Expanded(child: Column(children: [
            const Text('3h 30m',
                style: TextStyle(color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 6),
            Stack(alignment: Alignment.center, children: [
              const Divider(color: Colors.white12),
              Container(
                width: 28, height: 28,
                decoration: const BoxDecoration(
                    color: AppColors.gold, shape: BoxShape.circle),
                child: const Icon(Icons.flight, color: Colors.black, size: 14),
              ),
            ]),
            const SizedBox(height: 4),
            const Text('Nonstop',
                style: TextStyle(color: Colors.white38, fontSize: 11)),
          ])),
          _flightPoint('LXR', '11:30'),
        ]),
        const SizedBox(height: 14),
        const Divider(color: Colors.white10),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
          Text('Booking ID',
              style: TextStyle(color: Colors.white38, fontSize: 12)),
          Text('AMG-7832',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ]),
      ]),
    );
  }

  Widget _flightPoint(String code, String time) => Column(children: [
    Text(code,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold)),
    Text(time,
        style: const TextStyle(color: Colors.white38, fontSize: 12)),
  ]);

  Widget _buildCategories(BuildContext context) {
    final cats = [
      [Icons.account_balance_outlined, 'Temples'],
      [Icons.landscape_outlined, 'Deserts'],
      [Icons.sailing_outlined, 'Nile'],
      [Icons.beach_access_outlined, 'Beaches'],
      [Icons.museum_outlined, 'Museums'],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(
        title: 'Explore Egypt',
        actionLabel: 'See all',
        // ✅ بقت onExplore
        onAction: onExplore,
      ),
      const SizedBox(height: 14),
      SizedBox(
        height: 82,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: cats.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, i) => GestureDetector(
            // ✅ كل category بتروح لـ Explore tab
            onTap: onExplore,
            child: Column(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: AppColors.goldDim,
                  shape: BoxShape.circle,
                  border:
                  Border.all(color: AppColors.gold.withOpacity(0.3)),
                ),
                child: Icon(cats[i][0] as IconData,
                    color: AppColors.gold, size: 22),
              ),
              const SizedBox(height: 6),
              Text(cats[i][1] as String,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 11)),
            ]),
          ),
        ),
      ),
    ]);
  }

  Widget _buildToursRow(BuildContext context) {
    final tours = [
      {'img': AppAssets.pyramids,  'name': 'Giza Pyramids', 'loc': 'Cairo', 'rating': '4.9', 'price': '\$150/pax', 'tag': '1D'},
      {'img': AppAssets.karnak,    'name': 'Karnak Temple',  'loc': 'Luxor', 'rating': '4.8', 'price': '\$250/pax', 'tag': '3D2N'},
      {'img': AppAssets.abuSimbel, 'name': 'Abu Simbel',    'loc': 'Aswan', 'rating': '4.8', 'price': '\$200/pax', 'tag': '2D1N'},
    ];
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tours.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => TourCard(
          image: tours[i]['img']!,
          name: tours[i]['name']!,
          location: tours[i]['loc']!,
          rating: tours[i]['rating']!,
          price: tours[i]['price']!,
          tag: tours[i]['tag']!,
          // ✅ التفاصيل تفتح كشاشة جديدة — صح
          onTap: () => Navigator.pushNamed(context, '/tour-details'),
        ),
      ),
    );
  }
}