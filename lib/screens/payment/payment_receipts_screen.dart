// 📁 lib/screens/payment/payment_receipts_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../core/widgets/amun_button.dart';
import '../../core/widgets/amun_filter_chip.dart';
import '../../providers/payment_provider.dart';
import '../../data/models/payment_model.dart';


class PaymentReceiptsScreen extends StatefulWidget {
  const PaymentReceiptsScreen({super.key});

  @override
  State<PaymentReceiptsScreen> createState() => _PaymentReceiptsScreenState();
}

class _PaymentReceiptsScreenState extends State<PaymentReceiptsScreen> {
  int _activeFilter = 0;
  final _filters = ['All', 'Pending', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().loadMyPayments();
    });
  }

  List<PaymentModel> _getFiltered(List<PaymentModel> payments) {
    if (_activeFilter == 0) return payments;
    final status = _filters[_activeFilter].toLowerCase();
    return payments.where((p) => p.status.toLowerCase() == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PaymentProvider>();
    final filtered = _getFiltered(prov.payments);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const AmunAppBar(title: 'Payment Receipts'),
      body: Column(children: [

        // ─── Upload Button ───────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: AmunButton(
            label: 'Upload New Receipt',
            onTap: () => _showUploadSheet(context),
            icon: Icons.upload_file_outlined,
            isLoading: prov.isLoading,
          ),
        ),

        const SizedBox(height: 16),

        // ─── Filters ─────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                ? _buildEmpty()
                : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _receiptCard(filtered[i], context),
            ),
        ),
      ]),
    );
  }

  Widget _receiptCard(PaymentModel p, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(children: [

        // Receipt thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 60, height: 60,
            child: p.receiptImage != null
              ? Image.network(p.receiptImage!, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder())
              : _placeholder(),
          ),
        ),

        const SizedBox(width: 12),

        // Info
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Payment #${p.id}',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text(p.payableType.replaceAll('_', ' '),
                style: const TextStyle(
                    color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 3),
            Text(p.createdAt ?? '',
                style: const TextStyle(
                    color: Colors.white38, fontSize: 11)),
          ]),
        ),

        // Amount + Status
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('\$${p.amount}',
              style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 6),
          _statusBadge(p.status),
        ]),
      ]),
    );
  }

  Widget _placeholder() => Container(
    color: AppColors.bgInput,
    child: const Icon(Icons.receipt_long, color: Colors.white24, size: 28),
  );

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(status.toUpperCase(),
          style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              color: Colors.white24, size: 80),
          SizedBox(height: 16),
          Text('No receipts found',
              style: TextStyle(color: Colors.white54, fontSize: 16)),
        ],
      ),
    );
  }

  void _showUploadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          const Text('Upload Receipt',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _uploadOption(Icons.camera_alt_outlined, 'Take Photo', () => _pickAndUpload(ImageSource.camera)),
          const SizedBox(height: 12),
          _uploadOption(Icons.photo_library_outlined, 'Choose from Gallery', () => _pickAndUpload(ImageSource.gallery)),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (!mounted) return;
      final file = File(pickedFile.path);
      final ok = await context.read<PaymentProvider>().uploadReceipt(
        amount: 450.0,
        payableType: 'tour_bookings',
        payableId: 1, // Mock
        imageFile: file,
      );
      
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt uploaded successfully!')),
        );
      }
    }
  }

  Widget _uploadOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgInput,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(children: [
          Icon(icon, color: AppColors.gold, size: 22),
          const SizedBox(width: 14),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios,
              color: Colors.white24, size: 14),
        ]),
      ),
    );
  }
}


