import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/amun_filter_chip.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/place_model.dart';
import '../../providers/place_provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _activeFilter = 0;
  bool _isGrid = true;
  final _searchController = TextEditingController();

  final _filters = ['All', 'Temples', 'Deserts', 'Nile', 'Beaches', 'Museums'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceProvider>().loadAllPlaces();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    context.read<PlaceProvider>().search(q);
  }

  @override
  Widget build(BuildContext context) {
    final placeProv = context.watch<PlaceProvider>();
    final places = placeProv.places;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(children: [

          // ─── Header ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Explore Egypt',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(children: [
                    _toggleBtn(Icons.grid_view, true),
                    _toggleBtn(Icons.view_list, false),
                  ]),
                ),
              ]),

              const SizedBox(height: 14),

              // Search
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.bgInput,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(children: [
                  const Icon(Icons.search, color: Colors.white38, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Search places, tours...',
                        hintStyle:
                            TextStyle(color: Colors.white38, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        const Icon(Icons.tune, color: Colors.black, size: 16),
                  ),
                ]),
              ),

              const SizedBox(height: 12),

              // Filters
              SingleChildScrollView(
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

              const SizedBox(height: 14),

              SectionHeader(
                  title: placeProv.isLoading
                      ? 'Loading...'
                      : '${places.length} Places Found'),
            ]),
          ),

          const SizedBox(height: 12),

          // ─── Results ───────────────────────────────────────────────
          if (placeProv.isLoading)
            const Expanded(
                child: Center(
                    child: CircularProgressIndicator(color: AppColors.gold)))
          else if (placeProv.error != null)
            Expanded(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off,
                          color: Colors.white38, size: 48),
                      const SizedBox(height: 12),
                      Text(placeProv.error!,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 14)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<PlaceProvider>().loadAllPlaces(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold),
                        child: const Text('Retry',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ]),
              ),
            )
          else if (places.isEmpty)
            const Expanded(
              child: Center(
                  child: Text('No places found',
                      style: TextStyle(color: Colors.white38))),
            )
          else
            Expanded(
              child: _isGrid
                  ? GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: places.length,
                      itemBuilder: (_, i) =>
                          _PlaceGridCard(place: places[i], context: context),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: places.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          _PlaceListCard(place: places[i], context: context),
                    ),
            ),
        ]),
      ),
    );
  }

  Widget _toggleBtn(IconData icon, bool isGrid) {
    final active = _isGrid == isGrid;
    return GestureDetector(
      onTap: () => setState(() => _isGrid = isGrid),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            color: active ? Colors.black : Colors.white38, size: 18),
      ),
    );
  }
}

// ── Grid card ───────────────────────────────────────────────────────────
class _PlaceGridCard extends StatelessWidget {
  final PlaceModel place;
  final BuildContext context;
  const _PlaceGridCard({required this.place, required this.context});

  @override
  Widget build(BuildContext _) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/place-details', arguments: place),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                width: double.infinity,
                child: place.image != null
                    ? Image.network(place.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder())
                    : _placeholder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Icon(Icons.star,
                              color: AppColors.gold, size: 12),
                          const SizedBox(width: 3),
                          Text(place.displayRating,
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 11)),
                        ]),
                        Text(place.displayPrice,
                            style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ]),
                ]),
          ),
        ]),
      ),
    );
  }

  Widget _placeholder() => Container(
      color: AppColors.goldDim,
      child: const Icon(Icons.image_outlined, color: AppColors.gold));
}

// ── List card ───────────────────────────────────────────────────────────
class _PlaceListCard extends StatelessWidget {
  final PlaceModel place;
  final BuildContext context;
  const _PlaceListCard({required this.place, required this.context});

  @override
  Widget build(BuildContext _) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/place-details', arguments: place),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 80,
              height: 80,
              child: place.image != null
                  ? Image.network(place.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder())
                  : _placeholder(),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(place.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.star, color: AppColors.gold, size: 13),
              const SizedBox(width: 4),
              Text(place.displayRating,
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 13)),
            ]),
            const SizedBox(height: 6),
            Text(place.displayPrice,
                style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ])),
        ]),
      ),
    );
  }

  Widget _placeholder() => Container(
      color: AppColors.goldDim,
      child: const Icon(Icons.place, color: AppColors.gold));
}

