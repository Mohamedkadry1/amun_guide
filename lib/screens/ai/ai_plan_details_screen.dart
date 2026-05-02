// 📁 lib/screens/ai/ai_plan_details_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../core/widgets/amun_button.dart';
import '../../data/models/plan_model.dart';

class AiPlanDetailsScreen extends StatelessWidget {
  const AiPlanDetailsScreen({super.key});

  final _days = const [
    _PlanDay(day: 'Day 1', title: 'Giza Plateau', places: [
      _PlanStop(icon: Icons.wb_sunny_outlined,    title: 'Great Pyramids of Giza',  time: '08:00 AM', duration: '3 hrs'),
      _PlanStop(icon: Icons.landscape_outlined,    title: 'The Great Sphinx',        time: '11:00 AM', duration: '1 hr'),
      _PlanStop(icon: Icons.restaurant_outlined,   title: 'Lunch at Koshary El Tahrir', time: '01:00 PM', duration: '1 hr'),
      _PlanStop(icon: Icons.museum_outlined,       title: 'Egyptian Museum',         time: '03:00 PM', duration: '2 hrs'),
      _PlanStop(icon: Icons.shopping_bag_outlined, title: 'Khan el-Khalili Bazaar',  time: '06:00 PM', duration: '2 hrs'),
    ]),
    _PlanDay(day: 'Day 2', title: 'Old Cairo & Coptic District', places: [
      _PlanStop(icon: Icons.account_balance_outlined, title: 'Saladin Citadel',       time: '09:00 AM', duration: '2 hrs'),
      _PlanStop(icon: Icons.church_outlined,          title: 'Hanging Church',        time: '11:30 AM', duration: '1 hr'),
      _PlanStop(icon: Icons.sailing_outlined,         title: 'Nile Felucca Cruise',   time: '04:00 PM', duration: '2 hrs'),
      _PlanStop(icon: Icons.nightlife_outlined,       title: 'Zamalek Dinner',        time: '07:00 PM', duration: '2 hrs'),
    ]),
    _PlanDay(day: 'Day 3', title: 'Day Trip to Alexandria', places: [
      _PlanStop(icon: Icons.train_outlined,           title: 'Train to Alexandria',   time: '07:00 AM', duration: '2 hrs'),
      _PlanStop(icon: Icons.library_books_outlined,   title: 'Bibliotheca Alexandrina', time: '10:00 AM', duration: '2 hrs'),
      _PlanStop(icon: Icons.fort_outlined,            title: 'Qaitbay Citadel',       time: '01:00 PM', duration: '1.5 hrs'),
      _PlanStop(icon: Icons.train_outlined,           title: 'Return to Cairo',       time: '06:00 PM', duration: '2 hrs'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final plan = arg is PlanModel ? arg : null;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AmunAppBar(
        title: plan?.title ?? 'AI Generated Plan',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          const SizedBox(height: 16),

          // ─── AI Badge ──────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.goldDim,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            child: const Row(children: [
              Icon(Icons.auto_awesome, color: AppColors.gold, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'This itinerary was personalized by Amun AI based on your preferences and travel history.',
                  style: TextStyle(
                      color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 20),

          // ─── Trip Header ───────────────────────
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 160, width: double.infinity,
                child: Image.asset(AppAssets.pyramids, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        color: AppColors.bgCard,
                        child: const Icon(Icons.image,
                            color: Colors.white24, size: 60))),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 14, left: 16, right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan?.title ?? '3-Day Cairo Adventure',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: Colors.white60, size: 14),
                    const SizedBox(width: 5),
                    Text('${plan?.items.length ?? 0} Stops',
                        style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    const SizedBox(width: 14),
                    const Icon(Icons.attach_money,
                        color: Colors.white60, size: 14),
                    const SizedBox(width: 5),
                    const Text('Personalized',
                        style: TextStyle(color: Colors.white60, fontSize: 12)),
                  ]),
                ],
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // ─── Days ──────────────────────────────
          if (plan != null)
            ..._groupItemsByDay(plan.items).entries.map((e) => _buildRealDay(e.key, e.value, context))
          else
            ..._days.map((day) => _buildDay(day, context)),
        ]),
      ),

      // ─── Bottom Buttons ─────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1A16),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(children: [
          Expanded(
            child: AmunButton(
              label: 'Save Plan',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Plan saved to your trips!'),
                    backgroundColor: AppColors.gold,
                  ),
                );
              },
              icon: Icons.bookmark_outline,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AmunButton(
              label: 'View Tours',
              onTap: () => Navigator.pushNamed(context, '/explore'),
              variant: AmunButtonVariant.outlined,
              icon: Icons.explore_outlined,
            ),
          ),
        ]),
      ),
    );
  }

  Map<int, List<PlanItemModel>> _groupItemsByDay(List<PlanItemModel> items) {
    final groups = <int, List<PlanItemModel>>{};
    for (var item in items) {
      groups.putIfAbsent(item.dayIndex, () => []).add(item);
    }
    return groups;
  }

  Widget _buildRealDay(int dayIdx, List<PlanItemModel> items, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Day ${dayIdx + 1}',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              final place = e.value.place;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: const BoxDecoration(
                          color: AppColors.goldDim,
                          shape: BoxShape.circle),
                      child: const Icon(Icons.place, color: AppColors.gold, size: 16),
                    ),
                    if (!isLast)
                      Container(width: 1, height: 36, color: Colors.white12),
                  ]),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place?.title ?? 'Visit Place',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(place?.displayPrice ?? '',
                              style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  Widget _buildDay(_PlanDay day, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // Day header
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(day.day,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
          const SizedBox(width: 10),
          Text(day.title,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: FontStyle.italic)),
        ]),

        const SizedBox(height: 16),

        // Timeline
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: day.places.asMap().entries.map((e) {
              final isLast = e.key == day.places.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: const BoxDecoration(
                          color: AppColors.goldDim,
                          shape: BoxShape.circle),
                      child: Icon(e.value.icon,
                          color: AppColors.gold, size: 16),
                    ),
                    if (!isLast)
                      Container(
                          width: 1, height: 36, color: Colors.white12),
                  ]),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.value.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                                const SizedBox(height: 2),
                                Text(e.value.time,
                                    style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(e.value.duration,
                                style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}

class _PlanDay {
  final String day, title;
  final List<_PlanStop> places;
  const _PlanDay({
    required this.day,
    required this.title,
    required this.places});
}

class _PlanStop {
  final IconData icon;
  final String title, time, duration;
  const _PlanStop({
    required this.icon,
    required this.title,
    required this.time,
    required this.duration});
}
