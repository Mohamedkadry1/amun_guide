// 📁 lib/screens/tourist/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../providers/notification_provider.dart';
import '../../data/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _tab = 0;
  final _tabs = ['All', 'Trips', 'System', 'Social'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  List<NotificationModel> _getFiltered(List<NotificationModel> notifs) {
    if (_tab == 0) return notifs;
    return notifs.where((n) => n.type.toLowerCase() == _tabs[_tab].toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<NotificationProvider>();
    final filtered = _getFiltered(prov.notifications);

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
          child: prov.isLoading && prov.notifications.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : filtered.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _notifCard(filtered[i], context),
                  ),
        ),
      ]),
    );
  }

  Widget _notifCard(NotificationModel n, BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<NotificationProvider>().markRead(n.id),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: !n.isRead
              ? AppColors.gold.withValues(alpha: 0.06)
              : AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: !n.isRead
                  ? AppColors.gold.withValues(alpha: 0.25)
                  : Colors.white10),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: _getColorForType(n.type).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIconForType(n.type), color: _getColorForType(n.type), size: 20),
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
            Text(n.createdAt?.split('T').first ?? '',
                style: const TextStyle(color: Colors.white24, fontSize: 10)),
            if (!n.isRead) ...[
              const SizedBox(height: 6),
              Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(
                    color: AppColors.gold, shape: BoxShape.circle),
              ),
            ],
          ]),
        ]),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'trips': return Icons.flight_takeoff;
      case 'system': return Icons.auto_awesome;
      case 'social': return Icons.people_outline;
      default: return Icons.notifications_none;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'trips': return AppColors.gold;
      case 'system': return Colors.purpleAccent;
      case 'social': return Colors.blueAccent;
      default: return Colors.white38;
    }
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, color: Colors.white24, size: 60),
          SizedBox(height: 16),
          Text('No notifications', style: TextStyle(color: Colors.white54, fontSize: 16)),
        ],
      ),
    );
  }
}
