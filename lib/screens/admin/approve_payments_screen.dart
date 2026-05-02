// 📁 lib/screens/admin/approve_payments_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../core/widgets/amun_filter_chip.dart';
import '../../providers/admin_provider.dart';
import '../../data/models/payment_model.dart';

class ApprovePaymentsScreen extends StatefulWidget {
  const ApprovePaymentsScreen({super.key});

  @override
  State<ApprovePaymentsScreen> createState() => _ApprovePaymentsScreenState();
}

class _ApprovePaymentsScreenState extends State<ApprovePaymentsScreen> {
  int _activeFilter = 0;
  final _filters = ['Pending', 'All', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadPayments();
    });
  }

  List<PaymentModel> _getFiltered(List<PaymentModel> payments) {
    if (_activeFilter == 1) return payments;
    final status = _filters[_activeFilter].toLowerCase();
    return payments.where((p) => p.status.toLowerCase() == status).toList();
  }

  Future<void> _updateStatus(int id, String status) async {
    final ok = await context.read<AdminProvider>().updatePayment(id, status);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment $status successfully!'),
          backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AdminProvider>();
    final filtered = _getFiltered(prov.payments);
    final pendingCount = prov.payments.where((p) => p.status.toLowerCase() == 'pending').length;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const AmunAppBar(title: 'Approve Payments'),
      body: Column(children: [
        // ─── Filters ──────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                _filters.length,
                (i) => AmunFilterChip(
                  label: _filters[i],
                  isActive: _activeFilter == i,
                  onTap: () => setState(() => _activeFilter = i),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ─── List ─────────────────────────────────
        Expanded(
          child: prov.isLoading && prov.payments.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : filtered.isEmpty
                ? const Center(child: Text('No payments found', style: TextStyle(color: Colors.white38)))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _paymentCard(filtered[i]),
                  ),
        ),

        // ─── Bottom Bar ───────────────────────────
        if (pendingCount > 0)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1A16),
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: const BoxDecoration(
                    color: AppColors.goldDim, shape: BoxShape.circle),
                child: const Icon(Icons.pending_outlined,
                    color: AppColors.gold, size: 18),
              ),
              const SizedBox(width: 12),
              Text('$pendingCount pending receipt${pendingCount > 1 ? 's' : ''} today',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 14)),
            ]),
          ),
      ]),
    );
  }

  Widget _paymentCard(PaymentModel p) {
    final isPending = p.status.toLowerCase() == 'pending';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPending
              ? AppColors.gold.withValues(alpha: 0.3)
              : Colors.white10,
        ),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            width: 38, height: 38,
            decoration: const BoxDecoration(color: AppColors.bgInput, shape: BoxShape.circle),
            child: const Icon(Icons.person, color: Colors.white38),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('User #${p.payableId}', // Mock user info
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              Text(p.payableType.replaceAll('_', ' '),
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$${p.amount}',
                style: const TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 4),
            _statusBadge(p.status),
          ]),
        ]),

        const SizedBox(height: 12),

        // Receipt Image
        if (p.receiptImage != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity, height: 120,
              child: Image.network(p.receiptImage!, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      color: AppColors.bgInput,
                      child: const Icon(Icons.broken_image, color: Colors.white12))),
            ),
          ),

        if (isPending) ...[
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: _actionBtn('Reject', Colors.red, () => _updateStatus(p.id, 'Rejected')),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionBtn('Approve', Colors.green, () => _updateStatus(p.id, 'Approved')),
            ),
          ]),
        ],
      ]),
    );
  }

  Widget _actionBtn(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    final s = status.toLowerCase();
    if (s == 'approved' || s == 'completed') {
      color = Colors.green;
    } else if (s == 'rejected' || s == 'failed') {
      color = Colors.red;
    } else {
      color = AppColors.gold;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(status.toUpperCase(),
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
