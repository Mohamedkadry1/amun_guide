// 📁 lib/screens/explore/tour_details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/tours/providers/tour_provider.dart';
import '../../features/tours/models/tour_models.dart';
import '../../core/constants/app_colors.dart';

class TourDetailsScreen extends StatefulWidget {
  const TourDetailsScreen({super.key});

  @override
  State<TourDetailsScreen> createState() => _TourDetailsScreenState();
}

class _TourDetailsScreenState extends State<TourDetailsScreen> {
  int _selectedImageIndex = 0;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTourDetails();
  }

  Future<void> _loadTourDetails() async {
    // Get tour ID from route arguments (if passed)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tourProvider = context.read<TourProvider>();

      // Only load if no tour is currently selected
      if (tourProvider.selectedTour == null && mounted) {
        // Attempt to load, will show mock data if failed
        try {
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted && tourProvider.selectedTour == null) {
            // If still no data after delay, use mock
            final mockTour = _getMockTour();
            // Set the mock tour to the provider
            tourProvider.setSelectedTourMock(mockTour);
          }
        } catch (e) {
          // On error, use mock data
          if (mounted) {
            final mockTour = _getMockTour();
            tourProvider.setSelectedTourMock(mockTour);
          }
        }
      }
    });
  }

  /// Get image provider based on URL type (asset or network)
  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    }
    return NetworkImage(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Consumer<TourProvider>(
        builder: (context, tourProvider, _) {
          if (tourProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          if (tourProvider.errorMessage != null) {
            return Scaffold(
              backgroundColor: AppColors.bgDark,
              appBar: AppBar(
                backgroundColor: AppColors.bgDark,
                elevation: 0,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${tourProvider.errorMessage}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          final tour = tourProvider.selectedTour;
          if (tour == null) {
            return Scaffold(
              backgroundColor: AppColors.bgDark,
              appBar: AppBar(
                backgroundColor: AppColors.bgDark,
                elevation: 0,
              ),
              body: const Center(
                child: Text(
                  'No tour data available',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Main Image
                      Image(
                        image: _getImageProvider(
                          _selectedImageIndex == 0
                              ? tour.imageUrl
                              : tour.imageGallery[_selectedImageIndex - 1],
                        ),
                        fit: BoxFit.cover,
                      ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // Favorite Button
                      Positioned(
                        top: 50,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            if (tour.isFavorite) {
                              tourProvider.removeFromFavoriteTours(tour.id);
                            } else {
                              tourProvider.addToFavoriteTours(tour.id);
                            }
                          },
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
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tour Title and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tour.name,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: AppColors.gold, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                        '${tour.rating} (${tour.reviewsCount} reviews)'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '\$${tour.price.toInt()}',
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Per Person',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Quick Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoChip(
                            icon: Icons.calendar_today,
                            label: '${tour.duration} Days',
                          ),
                          _buildInfoChip(
                            icon: Icons.people,
                            label: '${tour.availableSeats} Seats',
                          ),
                          _buildInfoChip(
                            icon: Icons.signal_cellular_alt,
                            label: tour.difficulty,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Gallery
                      if (tour.imageGallery.isNotEmpty) ...[
                        const Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: tour.imageGallery.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) {
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedImageIndex = i + 1),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _selectedImageIndex == i + 1
                                          ? AppColors.gold
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image(
                                      image: _getImageProvider(
                                          tour.imageGallery[i]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Tabs
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildTab('Overview', 0),
                            _buildTab('Itinerary', 1),
                            _buildTab('Guide', 2),
                            _buildTab('Reviews', 3),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tab Content
                      if (_selectedTabIndex == 0) ...[
                        // Overview
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              tour.description,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Amenities
                            Text(
                              'Amenities',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: tour.amenities
                                  .map((amenity) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.gold.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color:
                                                AppColors.gold.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          amenity,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.gold,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 24),

                            // Location
                            Text(
                              'Pickup Location',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: AppColors.gold, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tour.pickupLocation,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ] else if (_selectedTabIndex == 1) ...[
                        // Itinerary
                        Column(
                          children: tourProvider.selectedTourItinerary
                              .map((item) => Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.bgCard,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: AppColors.gold,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Day ${item.day}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    item.location,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors.gold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          item.description,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            height: 1.5,
                                          ),
                                        ),
                                        if (item.activities.isNotEmpty) ...[
                                          const SizedBox(height: 12),
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 6,
                                            children: item.activities
                                                .map((activity) => Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.gold
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Text(
                                                        activity,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: AppColors.gold,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ] else if (_selectedTabIndex == 2) ...[
                        // Guide Info
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.bgCard,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        _getImageProvider(tour.guide.imageUrl),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    tour.guide.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.star,
                                          color: AppColors.gold, size: 16),
                                      const SizedBox(width: 4),
                                      Text('${tour.guide.rating} rating'),
                                      const SizedBox(width: 16),
                                      Text('${tour.guide.toursGuided} tours'),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    tour.guide.bio,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  if (tour.guide.languages.isNotEmpty)
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      alignment: WrapAlignment.center,
                                      children: tour.guide.languages
                                          .map((lang) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.gold
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  lang,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.gold,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            // TODO: Call guide
                                          },
                                          icon: const Icon(Icons.phone),
                                          label: const Text('Call'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            // TODO: Email guide
                                          },
                                          icon: const Icon(Icons.email),
                                          label: const Text('Email'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ] else if (_selectedTabIndex == 3) ...[
                        // Reviews
                        if (tourProvider.selectedTourReviews.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No reviews yet'),
                          )
                        else
                          Column(
                            children: tourProvider.selectedTourReviews
                                .map((review) => Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.bgCard,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundImage:
                                                    _getImageProvider(review
                                                            .userImage
                                                            .isNotEmpty
                                                        ? review.userImage
                                                        : 'https://via.placeholder.com/40'),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      review.userName,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      children: [
                                                        ...List.generate(
                                                          5,
                                                          (index) => Icon(
                                                            index <
                                                                    review
                                                                        .rating
                                                                ? Icons.star
                                                                : Icons
                                                                    .star_border,
                                                            color:
                                                                AppColors.gold,
                                                            size: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            review.comment,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<TourProvider>(
        builder: (context, tourProvider, _) {
          final tour = tourProvider.selectedTour;
          if (tour == null) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Add to itinerary / Ask AI
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Plan'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: tour.isFull
                        ? null
                        : () {
                            Navigator.of(context)
                                .pushNamed('/booking', arguments: tour.id);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          tour.isFull ? Colors.grey : AppColors.gold,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      tour.isFull ? 'FULL' : 'BOOK NOW',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _selectedTabIndex == index
                    ? AppColors.gold
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    _selectedTabIndex == index ? AppColors.gold : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(icon, color: AppColors.gold, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Provide mock tour data when API fails
  Tour _getMockTour() {
    return Tour(
      id: 1,
      name: 'Luxor Ancient Wonders',
      description:
          'Experience the magnificence of ancient Egypt with guided tours through the temples and monuments of Luxor.',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 3)),
      price: 450.0,
      rating: 4.8,
      reviewsCount: 156,
      imageUrl: 'assets/images/karnak.jpg',
      imageGallery: [
        'assets/images/karnak2.jpg',
        'assets/images/philae.jpg',
      ],
      itinerary: [],
      maxCapacity: 20,
      currentCapacity: 15,
      guide: Guide(
        id: 1,
        name: 'Ahmed Hassan',
        email: 'ahmed@example.com',
        phone: '+20123456789',
        imageUrl: 'assets/images/ahmed.png',
        bio: 'Expert Egyptologist with 15+ years of experience',
        languages: ['Arabic', 'English', 'French'],
        rating: 4.9,
        toursGuided: 250,
      ),
      pickupLocation: 'Cairo Hotel Zone',
      category: 'Cultural',
      amenities: [
        'Breakfast',
        'Lunch',
        'Bottled Water',
        'AC Transport',
        'Guide'
      ],
      isFavorite: false,
      tourType: 'multi-day',
      difficulty: 'moderate',
    );
  }
}
