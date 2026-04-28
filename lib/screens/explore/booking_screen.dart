import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/tours/providers/tour_provider.dart';
import '../../core/constants/app_colors.dart';

class BookingScreen extends StatefulWidget {
  final int tourId;

  const BookingScreen({super.key, required this.tourId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late PageController _pageController;
  int _currentStep = 0; // 0: Travelers, 1: Details, 2: Confirmation
  int _adultsCount = 1;
  int _childrenCount = 0;

  // Form fields
  final List<Map<String, TextEditingController>> _travelersControllers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeTravelersForm();
  }

  void _initializeTravelersForm() {
    _travelersControllers.clear();
    for (int i = 0; i < _adultsCount + _childrenCount; i++) {
      _travelersControllers.add({
        'firstName': TextEditingController(),
        'lastName': TextEditingController(),
        'email': TextEditingController(),
        'phone': TextEditingController(),
        'passport': TextEditingController(),
        'dob': TextEditingController(),
        'nationality': TextEditingController(),
      });
    }
  }

  void _updateTravelersCount() {
    _initializeTravelersForm();
    setState(() {});
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  void _submitBooking() async {
    final tourProvider = context.read<TourProvider>();
    final tour = tourProvider.selectedTour;
    if (tour == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tour data not found')),
      );
      return;
    }

    // Build travelers list
    final List<Map<String, dynamic>> travelers = [];
    for (int i = 0; i < _travelersControllers.length; i++) {
      final controller = _travelersControllers[i];
      travelers.add({
        'first_name': controller['firstName']!.text,
        'last_name': controller['lastName']!.text,
        'email': controller['email']!.text,
        'phone': controller['phone']!.text,
        'passport_number': controller['passport']!.text,
        'date_of_birth': controller['dob']!.text,
        'nationality': controller['nationality']!.text,
        'type': i < _adultsCount ? 'adult' : 'child',
      });
    }

    try {
      final confirmation = await tourProvider.createBooking(
        tourId: tour.id,
        travelers: travelers,
        adults: _adultsCount,
        children: _childrenCount,
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(
          '/payment-success',
          arguments: confirmation,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controllers in _travelersControllers) {
      controllers.forEach((_, controller) => controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Booking'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<TourProvider>(
        builder: (context, tourProvider, _) {
          final tour = tourProvider.selectedTour;
          if (tour == null) {
            return const Center(child: Text('No tour selected'));
          }

          return Column(
            children: [
              // Progress Indicator
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _currentStep >= index
                                  ? AppColors.gold
                                  : Colors.grey[700],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: _currentStep >= index
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ['Travelers', 'Details', 'Confirm'][index],
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const Divider(height: 1),

              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Step 1: Travelers Count
                    _buildTravelersCountStep(tour),
                    // Step 2: Travelers Details
                    _buildTravelersDetailsStep(tour),
                    // Step 3: Confirmation
                    _buildConfirmationStep(tour),
                  ],
                ),
              ),

              // Navigation Buttons
              Container(
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
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          child: const Text('Back'),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: tourProvider.isLoading
                            ? null
                            : (_currentStep < 2 ? _nextStep : _submitBooking),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: Colors.black,
                        ),
                        child: tourProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                              )
                            : Text(
                                _currentStep < 2 ? 'Next' : 'Complete Booking',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTravelersCountStep(tour) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How many travelers?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),

          // Tour Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price per person: \$${tour.price.toInt()}'),
                    Text('Available: ${tour.availableSeats}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Adults
          _buildTravelerCounter(
            label: 'Adults',
            value: _adultsCount,
            onIncrement: () {
              if (_adultsCount + _childrenCount < tour.availableSeats) {
                setState(() {
                  _adultsCount++;
                  _updateTravelersCount();
                });
              }
            },
            onDecrement: () {
              if (_adultsCount > 1) {
                setState(() {
                  _adultsCount--;
                  _updateTravelersCount();
                });
              }
            },
          ),
          const SizedBox(height: 24),

          // Children
          _buildTravelerCounter(
            label: 'Children',
            value: _childrenCount,
            onIncrement: () {
              if (_adultsCount + _childrenCount < tour.availableSeats) {
                setState(() {
                  _childrenCount++;
                  _updateTravelersCount();
                });
              }
            },
            onDecrement: () {
              if (_childrenCount > 0) {
                setState(() {
                  _childrenCount--;
                  _updateTravelersCount();
                });
              }
            },
          ),
          const SizedBox(height: 32),

          // Price Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gold.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price per person:'),
                    Text('\$${tour.price.toInt()}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Number of travelers:'),
                    Text('${_adultsCount + _childrenCount}'),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Price:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\$${(tour.price * (_adultsCount + _childrenCount)).toInt()}',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelerCounter({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.gold,
              onPressed: onDecrement,
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                '$value',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.gold,
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTravelersDetailsStep(tour) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _travelersControllers.length,
      itemBuilder: (context, index) {
        final isMale = index < _adultsCount;
        return _buildTravelerForm(
          index,
          isMale ? 'Adult ${index + 1}' : 'Child ${index - _adultsCount + 1}',
        );
      },
    );
  }

  Widget _buildTravelerForm(int index, String title) {
    final controller = _travelersControllers[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.bgCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller['firstName'],
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller['lastName'],
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller['email'],
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller['phone'],
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller['passport'],
              decoration: InputDecoration(
                labelText: 'Passport Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller['dob'],
              decoration: InputDecoration(
                labelText: 'Date of Birth (YYYY-MM-DD)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller['nationality'],
              decoration: InputDecoration(
                labelText: 'Nationality',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationStep(tour) {
    final totalPrice = tour.price * (_adultsCount + _childrenCount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),

          // Tour Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tour Details',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tour:'),
                    Text(tour.name),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Duration:'),
                    Text('${tour.duration} days'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Guide:'),
                    Text(tour.guide.name),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Travelers
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travelers',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Adults:'),
                    Text('$_adultsCount'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Children:'),
                    Text('$_childrenCount'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:'),
                    Text('${_adultsCount + _childrenCount}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Price
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gold.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Price per person:'),
                    Text('\$${tour.price.toInt()}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Travelers:'),
                    Text('${_adultsCount + _childrenCount}'),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Price:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\$${totalPrice.toInt()}',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
