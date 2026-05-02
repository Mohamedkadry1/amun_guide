// 📁 lib/core/widgets/place_card.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum PlaceCardStyle { grid, list }

class PlaceCard extends StatelessWidget {
  final String image;
  final String name;
  final String location;
  final String rating;
  final String price;
  final String? category;
  final bool isSaved;
  final PlaceCardStyle style;
  final VoidCallback onTap;
  final VoidCallback? onSave;

  const PlaceCard({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    this.category,
    this.isSaved = false,
    this.style = PlaceCardStyle.grid,
    required this.onTap,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return style == PlaceCardStyle.grid
        ? _gridCard()
        : _listCard();
  }

  // ─── Grid Style ───────────────────────────────────────
  Widget _gridCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 120, width: double.infinity,
                  child: Image.asset(image, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          color: AppColors.bgInput,
                          child: const Icon(Icons.image,
                              color: Colors.white24, size: 40))),
                ),
              ),
              // Save button
              if (onSave != null)
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: onSave,
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_outline,
                        color: isSaved ? AppColors.gold : Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              // Category
              if (category != null)
                Positioned(
                  bottom: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(category!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
            ]),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(location,
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 11)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Icon(Icons.star,
                            color: AppColors.gold, size: 12),
                        const SizedBox(width: 3),
                        Text(rating,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 11)),
                      ]),
                      Text(price,
                          style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── List Style ───────────────────────────────────────
  Widget _listCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 90, height: 90,
              child: Image.asset(image, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      color: AppColors.bgInput,
                      child: const Icon(Icons.image,
                          color: Colors.white24, size: 32))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (category != null)
                  Text(category!,
                      style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                if (category != null) const SizedBox(height: 3),
                Text(name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.location_on_outlined,
                      color: Colors.white38, size: 12),
                  const SizedBox(width: 3),
                  Text(location,
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 12)),
                ]),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.star,
                          color: AppColors.gold, size: 13),
                      const SizedBox(width: 3),
                      Text(rating,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                    ]),
                    Text(price,
                        style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          if (onSave != null)
            IconButton(
              onPressed: onSave,
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_outline,
                color: isSaved ? AppColors.gold : Colors.white38,
                size: 20,
              ),
            ),
        ]),
      ),
    );
  }
}
