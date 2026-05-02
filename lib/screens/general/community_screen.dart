// 📁 lib/screens/general/community_screen.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/amun_filter_chip.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _activeFilter = 0;
  final _filters = ['All', 'Tips', 'Reviews', 'Questions', 'Photos'];

  final _posts = [
    _Post(
      avatar: AppAssets.anna,
      name: 'Anna K.',
      time: '2h ago',
      tag: 'Tips',
      tagColor: Colors.blueAccent,
      text: 'Pro tip for Karnak Temple: Go at 6AM right when it opens. You\'ll have the Hypostyle Hall almost to yourself for 30 minutes. Absolute magic! 🏛️',
      image: AppAssets.karnak,
      likes: 48,
      comments: 12,
      isLiked: true,
    ),
    _Post(
      avatar: AppAssets.david,
      name: 'David Miller',
      time: '5h ago',
      tag: 'Review',
      tagColor: Colors.green,
      text: 'Just finished the Nile Cruise from Luxor to Aswan. 3 days of pure bliss. The sunsets on the Nile are indescribable. 10/10 would recommend to everyone! 🚢🌅',
      image: AppAssets.nileSunset,
      likes: 93,
      comments: 21,
      isLiked: false,
    ),
    _Post(
      avatar: AppAssets.elena,
      name: 'Elena Rossi',
      time: '1d ago',
      tag: 'Question',
      tagColor: AppColors.gold,
      text: 'Has anyone visited Siwa Oasis in November? Is it too cold for swimming in the springs? Planning a trip and would love some advice! 🌴',
      image: AppAssets.siwa,
      likes: 15,
      comments: 34,
      isLiked: false,
    ),
    _Post(
      avatar: AppAssets.marcus,
      name: 'Marcus L.',
      time: '2d ago',
      tag: 'Photos',
      tagColor: Colors.purpleAccent,
      text: 'Abu Simbel at sunrise. No filter needed — Egypt does it better than any Instagram preset. 📸✨',
      image: AppAssets.abuSimbel,
      likes: 201,
      comments: 44,
      isLiked: true,
    ),
  ];

  List<_Post> get _filtered => _activeFilter == 0
      ? _posts
      : _posts.where((p) => p.tag == _filters[_activeFilter].replaceAll('s', '')).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(children: [

          // ─── Header ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Community',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => _showNewPostSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(children: const [
                      Icon(Icons.add, color: Colors.black, size: 16),
                      SizedBox(width: 5),
                      Text('Post',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ─── Filters ────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (i) => AmunFilterChip(
                  label: _filters[i],
                  isActive: _activeFilter == i,
                  onTap: () => setState(() => _activeFilter = i),
                )),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ─── Posts ──────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _postCard(_filtered[i], i, context),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _postCard(_Post post, int index, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/post-details'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Author
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(children: [
              ClipOval(
                child: SizedBox(
                  width: 38, height: 38,
                  child: Image.asset(post.avatar, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          color: AppColors.bgInput,
                          child: const Icon(Icons.person,
                              color: Colors.white38))),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(post.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  Text(post.time,
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 11)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: post.tagColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: post.tagColor.withValues(alpha: 0.3)),
                ),
                child: Text(post.tag,
                    style: TextStyle(
                        color: post.tagColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ]),
          ),

          // Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(post.text,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5)),
          ),

          const SizedBox(height: 10),

          // Image
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: SizedBox(
              height: 180, width: double.infinity,
              child: Image.asset(post.image, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: AppColors.bgInput,
                      child: const Icon(Icons.image,
                          color: Colors.white24, size: 50))),
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(children: [
              GestureDetector(
                onTap: () => setState(() {
                  _posts[index].isLiked = !_posts[index].isLiked;
                  _posts[index].likes += _posts[index].isLiked ? 1 : -1;
                }),
                child: Row(children: [
                  Icon(
                    post.isLiked
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: post.isLiked ? Colors.red : Colors.white38,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text('${post.likes}',
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13)),
                ]),
              ),
              const SizedBox(width: 20),
              Row(children: [
                const Icon(Icons.chat_bubble_outline,
                    color: Colors.white38, size: 20),
                const SizedBox(width: 5),
                Text('${post.comments}',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 13)),
              ]),
              const Spacer(),
              const Icon(Icons.share_outlined,
                  color: Colors.white38, size: 20),
            ]),
          ),
        ]),
      ),
    );
  }

  void _showNewPostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          const Text('New Post',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bgInput,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: const TextField(
              maxLines: 4,
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Share your Egypt experience...',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            _attachBtn(Icons.photo_library_outlined, 'Photo'),
            const SizedBox(width: 10),
            _attachBtn(Icons.location_on_outlined, 'Location'),
            const SizedBox(width: 10),
            _attachBtn(Icons.tag, 'Tag'),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Publish Post',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _attachBtn(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.bgInput,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white10),
    ),
    child: Row(children: [
      Icon(icon, color: AppColors.gold, size: 16),
      const SizedBox(width: 6),
      Text(label,
          style: const TextStyle(color: Colors.white54, fontSize: 12)),
    ]),
  );
}

class _Post {
  final String avatar, name, time, tag, text, image;
  final Color tagColor;
  int likes, comments;
  bool isLiked;

  _Post({
    required this.avatar,
    required this.name,
    required this.time,
    required this.tag,
    required this.tagColor,
    required this.text,
    required this.image,
    required this.likes,
    required this.comments,
    required this.isLiked,
  });
}
