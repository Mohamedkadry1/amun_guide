// 📁 lib/screens/tourist/notifications_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _tab = 0;
  final _tabs = ['All', 'Trips', 'System', 'Social'];

  final _notifications = [
    _Notif(icon: Icons.flight_takeoff, color: AppColors.gold,
        title: 'Your trip to Luxor is confirmed!',
        body: 'Booking ID: AMG-7832 — 12 Oct 2024',
        time: '2h ago', isNew: true, type: 'Trips'),
    _Notif(icon: Icons.auto_awesome, color: Colors.purpleAccent,
        title: 'AI Plan Ready',
        body: 'Your 3-day Alexandria itinerary is ready to view.',
        time: '5h ago', isNew: true, type: 'System'),
    _Notif(icon: Icons.people_outline, color: Colors.blueAccent,
        title: 'Anna liked your review',
        body: 'Anna K. liked your review of Karnak Temple.',
        time: '1d ago', isNew: false, type: 'Social'),
    _Notif(icon: Icons.payment_outlined, color: Colors.greenAccent,
        title: 'Payment Approved',
        body: 'Your receipt for Nile Cruise has been approved.',
        time: '2d ago', isNew: false, type: 'Trips'),
    _Notif(icon: Icons.campaign_outlined, color: AppColors.gold,
        title: 'New Tour Available',
        body: 'Check out the new Siwa Oasis adventure tour!',
        time: '3d ago', isNew: false, type: 'System'),
  ];

  List<_Notif> get _filtered => _tab == 0
      ? _notifications
      : _notifications
      .where((n) => n.type == _tabs[_tab])
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const AmunAppBar(title: 'Notifications'),
      body: Column(children: [

        // Filter Tabs
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_tabs.length, (i) => GestureDetector(
                onTap: () => setState(() => _tab = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _tab == i ? AppColors.gold : AppColors.bgCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: _tab == i
                            ? AppColors.gold
                            : Colors.white12),
                  ),
                  child: Text(_tabs[i],
                      style: TextStyle(
                          color: _tab == i ? Colors.black : Colors.white54,
                          fontSize: 13,
                          fontWeight: _tab == i
                              ? FontWeight.bold
                              : FontWeight.normal)),
                ),
              )),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: _filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _notifCard(_filtered[i]),
          ),
        ),
      ]),
    );
  }

  Widget _notifCard(_Notif n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: n.isNew
            ? AppColors.gold.withOpacity(0.06)
            : AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: n.isNew
                ? AppColors.gold.withOpacity(0.25)
                : Colors.white10),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: n.color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(n.icon, color: n.color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(n.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(n.body,
                style: const TextStyle(
                    color: Colors.white54, fontSize: 12, height: 1.4)),
          ]),
        ),
        const SizedBox(width: 8),
        Column(children: [
          Text(n.time,
              style: const TextStyle(color: Colors.white24, fontSize: 10)),
          if (n.isNew) ...[
            const SizedBox(height: 6),
            Container(
              width: 8, height: 8,
              decoration: const BoxDecoration(
                  color: AppColors.gold, shape: BoxShape.circle),
            ),
          ],
        ]),
      ]),
    );
  }
}

class _Notif {
  final IconData icon;
  final Color color;
  final String title, body, time, type;
  final bool isNew;
  const _Notif({
    required this.icon, required this.color,
    required this.title, required this.body,
    required this.time, required this.isNew, required this.type,
  });
}