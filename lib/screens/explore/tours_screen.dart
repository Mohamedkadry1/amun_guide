import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/tours/providers/tour_provider.dart';
import '../../features/tours/models/tour_models.dart';
import '../../core/constants/app_colors.dart';

class ToursScreen extends StatefulWidget {
  const ToursScreen({super.key});

  @override
  State<ToursScreen> createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  late TextEditingController _searchController;
  bool _isGridView = true;
  int _activeCategory = 0;
  int _activeDifficulty = 0;
  RangeValues _priceRange = const RangeValues(0, 1000);

  final List<String> _categories = [
    'All Tours',
    'Cultural',
    'Adventure',
    'Desert',
    'Nile',
    'Beach'
  ];

  final List<String> _difficulties = ['All Levels', 'Easy', 'Moderate', 'Hard'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializeData();
  }

  void _initializeData() {
    final provider = context.read<TourProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadTours();
    });
  }

  void _onSearchChanged(String query) {
    final provider = context.read<TourProvider>();
    final categoryFilter =
        _activeCategory == 0 ? null : _categories[_activeCategory];
    final difficultyFilter = _activeDifficulty == 0
        ? null
        : _difficulties[_activeDifficulty].toLowerCase();

    provider.loadTours(
      category: categoryFilter,
      difficulty: difficultyFilter,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      search: query.isEmpty ? null : query,
    );
  }

  void _onCategoryChanged(int index) {
    setState(() {
      _activeCategory = index;
    });
    _applyFilters();
  }

  void _onDifficultyChanged(int index) {
    setState(() {
      _activeDifficulty = index;
    });
    _applyFilters();
  }

  void _onPriceChanged(RangeValues values) {
    setState(() {
      _priceRange = values;
    });
    _applyFilters();
  }

  void _applyFilters() {
    final provider = context.read<TourProvider>();
    final categoryFilter =
        _activeCategory == 0 ? null : _categories[_activeCategory];
    final difficultyFilter = _activeDifficulty == 0
        ? null
        : _difficulties[_activeDifficulty].toLowerCase();

    provider.loadTours(
      category: categoryFilter,
      difficulty: difficultyFilter,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      search: _searchController.text.isEmpty ? null : _searchController.text,
    );
  }

  /// Get image provider based on URL type (asset or network)
  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    }
    return NetworkImage(imageUrl);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tours & Experiences'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_3x3),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Consumer<TourProvider>(
        builder: (context, tourProvider, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search tours...',
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.gold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),

                // Category Filter
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _categories.length,
                    itemBuilder: (ctx, i) {
                      return GestureDetector(
                        onTap: () => _onCategoryChanged(i),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _activeCategory == i
                                ? AppColors.gold
                                : AppColors.bgCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _activeCategory == i
                                  ? AppColors.gold
                                  : Colors.transparent,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _categories[i],
                              style: TextStyle(
                                color: _activeCategory == i
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Difficulty Filter
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Difficulty Level',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _difficulties.length,
                          itemBuilder: (ctx, i) {
                            return GestureDetector(
                              onTap: () => _onDifficultyChanged(i),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _activeDifficulty == i
                                      ? AppColors.gold
                                      : AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    _difficulties[i],
                                    style: TextStyle(
                                      color: _activeDifficulty == i
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Price Range Filter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price Range: \$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 2000,
                        onChanged: _onPriceChanged,
                        activeColor: AppColors.gold,
                      ),
                    ],
                  ),
                ),

                // Tours List/Grid
                Builder(
                  builder: (context) {
                    final List<Tour> tours = tourProvider.tours.isNotEmpty
                        ? tourProvider.tours
                        : (tourProvider.errorMessage != null
                            ? _getMockTours()
                            : []);

                    if (tourProvider.isLoading && tourProvider.tours.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(color: AppColors.gold),
                      );
                    } else if (tours.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No tours found',
                            style: TextStyle(color: Colors.white)),
                      );
                    } else {
                      return _isGridView
                          ? _buildGridView(tours)
                          : _buildListView(tours);
                    }
                  },
                ),

                // Load More Button
                if (tourProvider.hasMorePages && tourProvider.tours.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        final categoryFilter = _activeCategory == 0
                            ? null
                            : _categories[_activeCategory];
                        final difficultyFilter = _activeDifficulty == 0
                            ? null
                            : _difficulties[_activeDifficulty].toLowerCase();

                        context.read<TourProvider>().loadMoreTours(
                              category: categoryFilter,
                              difficulty: difficultyFilter,
                              minPrice: _priceRange.start,
                              maxPrice: _priceRange.end,
                              search: _searchController.text.isEmpty
                                  ? null
                                  : _searchController.text,
                            );
                      },
                      child: tourProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.gold,
                              ),
                            )
                          : const Text('Load More'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<Tour> tours) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        return _buildTourCard(context, tour);
      },
    );
  }

  Widget _buildListView(List<Tour> tours) {
    return Column(
      children: tours.map((tour) {
        return _buildTourListItem(context, tour);
      }).toList(),
    );
  }

  Widget _buildTourCard(BuildContext context, Tour tour) {
    return GestureDetector(
      onTap: () {
        context.read<TourProvider>().loadTourDetails(tour.id);
        Navigator.of(context).pushNamed('/tour-details');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      image: DecorationImage(
                        image: _getImageProvider(tour.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tour.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: AppColors.gold,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tour.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.gold, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${tour.rating} (${tour.reviewsCount})',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${tour.price.toInt()}',
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${tour.duration}d',
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTourListItem(BuildContext context, Tour tour) {
    return GestureDetector(
      onTap: () {
        context.read<TourProvider>().loadTourDetails(tour.id);
        Navigator.of(context).pushNamed('/tour-details');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.bgCard,
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
                image: DecorationImage(
                  image: _getImageProvider(tour.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tour.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.gold, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${tour.rating}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${tour.duration} days',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${tour.price.toInt()}',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Icon(
                        tour.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: AppColors.gold,
                        size: 20,
                      ),
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

  /// Provide mock tours data when API fails
  List<Tour> _getMockTours() {
    return [
      Tour(
        id: 1,
        name: 'Luxor Temples Tour',
        description:
            'Explore the magnificent ancient temples of Luxor including Karnak and Luxor Temple',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
        price: 120,
        rating: 4.8,
        reviewsCount: 245,
        imageUrl: 'assets/images/karnak.jpg',
        imageGallery: [],
        itinerary: [],
        maxCapacity: 20,
        currentCapacity: 15,
        guide: Guide(
          id: 1,
          name: 'Ahmed Hassan',
          email: 'ahmed@example.com',
          phone: '+20123456789',
          imageUrl: 'https://via.placeholder.com/100?text=Ahmed',
          bio: 'Experienced Egyptologist',
          languages: ['Arabic', 'English', 'French'],
          rating: 4.9,
          toursGuided: 250,
        ),
        pickupLocation: 'Cairo',
        category: 'Cultural',
        amenities: ['Breakfast', 'Lunch', 'Transport'],
        isFavorite: false,
        tourType: 'one-day',
        difficulty: 'easy',
      ),
      Tour(
        id: 2,
        name: 'Nile Sunset Cruise',
        description:
            'Enjoy a magical dinner cruise on the Nile River with live entertainment',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
        price: 85,
        rating: 4.9,
        reviewsCount: 382,
        imageUrl: 'assets/images/nile_sunset.jpg',
        imageGallery: [],
        itinerary: [],
        maxCapacity: 30,
        currentCapacity: 25,
        guide: Guide(
          id: 2,
          name: 'Fatima Ali',
          email: 'fatima@example.com',
          phone: '+20987654321',
          imageUrl: 'https://via.placeholder.com/100?text=Fatima',
          bio: 'Expert in Nile tourism',
          languages: ['Arabic', 'English', 'Spanish'],
          rating: 4.8,
          toursGuided: 320,
        ),
        pickupLocation: 'Cairo',
        category: 'Nile',
        amenities: ['Dinner', 'Entertainment', 'Beverages'],
        isFavorite: false,
        tourType: 'evening',
        difficulty: 'easy',
      ),
      Tour(
        id: 3,
        name: 'Abu Simbel & Aswan Adventure',
        description:
            'Thrilling adventure to the colossal temples of Abu Simbel and Aswan attractions',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 2)),
        price: 180,
        rating: 4.7,
        reviewsCount: 156,
        imageUrl: 'assets/images/abu_simbel.jpg',
        imageGallery: [],
        itinerary: [],
        maxCapacity: 15,
        currentCapacity: 10,
        guide: Guide(
          id: 3,
          name: 'Mohamed Ibrahim',
          email: 'mohamed@example.com',
          phone: '+20555123456',
          imageUrl: 'https://via.placeholder.com/100?text=Mohamed',
          bio: 'Desert safari specialist',
          languages: ['Arabic', 'English', 'German'],
          rating: 4.7,
          toursGuided: 180,
        ),
        pickupLocation: 'Cairo',
        category: 'Adventure',
        amenities: ['Flights', 'Meals', 'Hotels'],
        isFavorite: false,
        tourType: 'multi-day',
        difficulty: 'moderate',
      ),
      Tour(
        id: 4,
        name: 'Giza Pyramids Experience',
        description:
            'See the iconic Great Pyramids and the mysterious Great Sphinx',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
        price: 75,
        rating: 4.9,
        reviewsCount: 512,
        imageUrl: 'assets/images/pyramids.jpg',
        imageGallery: [],
        itinerary: [],
        maxCapacity: 25,
        currentCapacity: 20,
        guide: Guide(
          id: 4,
          name: 'Noor Hassan',
          email: 'noor@example.com',
          phone: '+20666123456',
          imageUrl: 'https://via.placeholder.com/100?text=Noor',
          bio: 'Pyramid specialist guide',
          languages: ['Arabic', 'English', 'Italian'],
          rating: 4.8,
          toursGuided: 400,
        ),
        pickupLocation: 'Cairo',
        category: 'Cultural',
        amenities: ['Breakfast', 'Transport', 'Photography spots'],
        isFavorite: false,
        tourType: 'half-day',
        difficulty: 'easy',
      ),
      Tour(
        id: 5,
        name: 'Alexandria Beach & Citadel',
        description:
            'Beach day combined with the historic Alexandria Citadel and Mediterranean coast',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
        price: 95,
        rating: 4.6,
        reviewsCount: 198,
        imageUrl: 'assets/images/alexandria.jpg',
        imageGallery: [],
        itinerary: [],
        maxCapacity: 30,
        currentCapacity: 22,
        guide: Guide(
          id: 5,
          name: 'Layla Sayed',
          email: 'layla@example.com',
          phone: '+20777123456',
          imageUrl: 'https://via.placeholder.com/100?text=Layla',
          bio: 'Coastal tourism expert',
          languages: ['Arabic', 'English', 'French'],
          rating: 4.7,
          toursGuided: 270,
        ),
        pickupLocation: 'Cairo',
        category: 'Beach',
        amenities: ['Beach access', 'Lunch', 'Transport'],
        isFavorite: false,
        tourType: 'full-day',
        difficulty: 'easy',
      ),
      Tour(
        id: 6,
        name: 'Siwa Oasis Desert Escape',
        description:
            'Remote desert oasis adventure with unique culture and salt lakes',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 3)),
        price: 280,
        rating: 4.5,
        reviewsCount: 87,
        imageUrl: 'assets/images/siwa.jpg',
        imageGallery: [],
        itinerary: [],
        maxCapacity: 12,
        currentCapacity: 8,
        guide: Guide(
          id: 6,
          name: 'Hassan Bedouin',
          email: 'hassan@example.com',
          phone: '+20888123456',
          imageUrl: 'https://via.placeholder.com/100?text=Hassan',
          bio: 'Oasis adventure guide',
          languages: ['Arabic', 'English'],
          rating: 4.6,
          toursGuided: 150,
        ),
        pickupLocation: 'Cairo',
        category: 'Adventure',
        amenities: ['All meals', 'Camping', 'Salt lake visit'],
        isFavorite: false,
        tourType: 'multi-day',
        difficulty: 'hard',
      ),
    ];
  }
}
