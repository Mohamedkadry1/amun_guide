// 📁 lib/screens/tourist/my_bookings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/tours/providers/tour_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_app_bar.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int _activeFilter = 0; // 0: All, 1: Upcoming, 2: Past, 3: Cancelled
  final _filters = ['All', 'Upcoming', 'Past', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TourProvider>(context, listen: false).loadMyBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AmunAppBar(title: 'My Bookings'),
      body: SafeArea(
        child: Column(children: [
          // ─── Filters ────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 12),
              child: Row(
                children: List.generate(
                  _filters.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_filters[i]),
                      selected: _activeFilter == i,
                      onSelected: (selected) {
                        setState(() => _activeFilter = i);
                      },
                      backgroundColor: AppColors.bgCard,
                      selectedColor: AppColors.gold,
                      labelStyle: TextStyle(
                        color:
                            _activeFilter == i ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide(
                        color: _activeFilter == i
                            ? AppColors.gold
                            : Colors.white10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ─── Bookings List ──────────────────────────
          Expanded(
            child: Consumer<TourProvider>(
              builder: (context, tourProvider, __) {
                if (tourProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  );
                }

                final bookings = tourProvider.myBookings;

                if (bookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          size: 64,
                          color: Colors.white30,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No bookings yet',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: bookings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _bookingCard(bookings[i]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _bookingCard(dynamic booking) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to booking details
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tour Title
            Text(
              booking.tourName ?? 'Tour',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Booking Info
            Row(
              children: [
                Icon(Icons.people, size: 16, color: AppColors.gold),
                const SizedBox(width: 6),
                Text(
                  '${booking.groupSize ?? 1} Person(s)',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.gold),
                const SizedBox(width: 6),
                Text(
                  booking.startDate ?? 'N/A',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 16, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Text(
                      '${booking.totalPrice ?? 0} EGP',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(booking.status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _getStatusText(booking.status),
                    style: TextStyle(
                      color: _getStatusColor(booking.status),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.greenAccent;
      case 'pending':
        return Colors.orangeAccent;
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.blueAccent;
    }
  }

  String _getStatusText(String? status) {
    return status?.replaceFirst(status[0], status[0].toUpperCase()) ??
        'Unknown';
  }
}
