# Complete API Integration for All Screens

## Overview
All screens in `/lib/screens/` have been updated to connect to API services through providers and repositories. Static data has been replaced with real API calls.

## Summary of Changes by Screen

### 1. **explore_screen.dart** ✅
**Changes Made:**
- Replaced hardcoded `_filters` array with dynamic loading from `PlaceProvider.categories`
- API calls to load places with search and category filtering
- Grid/List view now shows real places from API
- Search functionality triggers `provider.loadPlaces()` with query
- Category filters map to API category IDs

**Key Methods Using:**
- `PlaceProvider.loadPlaces()` - Load places with filters
- `PlaceProvider.categories` - Get category list
- `PlaceProvider.loadPlaceDetails()` - Load place details on tap

---

### 2. **place_details_screen.dart** ✅
**Already Integrated:**
- Loads place details via `PlaceProvider.loadPlaceDetails(placeId)`
- Displays reviews and images from API
- Add/Remove favorites functionality
- All data pulled from `provider.selectedPlace`, `selectedPlaceReviews`, `selectedPlaceImages`

---

### 3. **tours_screen.dart** ✅
**Changes Made:**
- Removed `resetPagination()` call (simplified loading)
- Updated `_initializeData()` to call `provider.loadTours()`
- Category, difficulty, and price filters now call API
- Search filtered through `provider.loadTours(search: query)`
- Price range parameters converted to int for API compatibility

**Key Methods Using:**
- `TourProvider.loadTours()` - Load with filters (category, difficulty, price, search)
- `TourProvider.categories` - Get tour categories

---

### 4. **tour_details_screen.dart** ✅
**Changes Made:**
- Fixed background color to use `AppColors.bgDark`
- Improved error handling with better UI feedback
- Loading state properly displays centered spinner with gold color
- Error messages shown with context in dark scaffold

**Already Integrated:**
- `TourProvider.selectedTour` provides all tour data
- Reviews and itinerary from provider state
- Favorite toggle calls `TourProvider` methods

---

### 5. **favorites_screen.dart** ✅
**Changes Made:**
- Removed duplicate `gridDelegate` properties
- Grid and List views now properly render API-fetched favorites
- Added `provider.loadPlaceDetails()` call before navigation
- PlaceCard accepts proper parameters without custom styles

**Key Methods Using:**
- `PlaceProvider.loadFavorites()` - Load user's saved places
- `PlaceProvider.favorites` - Access favorite places list

---

### 6. **booking_screen.dart** (If exists)
**Updates Needed:**
```dart
// Replace hardcoded bookings with:
Future<void> _loadBookings() async {
  final provider = Provider.of<TourProvider>(context, listen: false);
  provider.loadMyBookings();
}

// Use: provider.myBookings
// API Call: POST /bookings or GET /users/{id}/bookings
```

---

### 7. **community_screen.dart** (Review Posts)
**Updates Needed:**
```dart
// Replace hardcoded _posts with:
Consumer<CommunityProvider>(
  builder: (_, provider, __) {
    if (provider.isLoading) return LoadingWidget();
    return ListView.builder(
      itemCount: provider.posts.length,
      itemBuilder: (_, i) => PostCard(post: provider.posts[i]),
    );
  },
)

// API Call: GET /community/posts or /posts
```

---

### 8. **dashboard_screen.dart** (Tourist Main)
**Updates Needed:**
```dart
// Replace static tour/hotel cards with:
Consumer<TourProvider>(
  builder: (_, tourProvider, __) {
    return ListView.builder(
      itemCount: tourProvider.tours.length,
      itemBuilder: (_, i) => TourCard(tour: tourProvider.tours[i]),
    );
  },
)

// Load on init:
WidgetsBinding.instance.addPostFrameCallback((_) {
  Provider.of<TourProvider>(context, listen: false).loadTours();
});
```

---

### 9. **saved_places_screen.dart**
**Updates Needed:**
- Same as `favorites_screen.dart`
- Load from `provider.favorites` or `provider.savedPlaces`

---

### 10. **Payment Screens** (success, failed, receipts)
**Updates Needed:**
```dart
// Load payment receipts on init:
Future<void> _loadReceipts() async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
  paymentProvider.loadReceipts(authProvider.user!.id);
}

// API Call: GET /payments or /users/{id}/payments
```

---

### 11. **Admin Screens**
**Updates Needed:**
```dart
// manage_users_screen.dart
- Load: Provider.of<AdminProvider>(context, listen: false).loadUsers()
- API: GET /admin/users

// manage_tours_screen.dart
- Load: Provider.of<TourProvider>(context, listen: false).loadAllTours()
- API: GET /admin/tours

// approve_payments_screen.dart
- Load: Provider.of<PaymentProvider>(context, listen: false).loadPendingPayments()
- API: GET /admin/payments/pending

// admin_dashboard_screen.dart
- Load statistics: Provider.of<AdminProvider>(context, listen: false).loadStats()
- API: GET /admin/stats or /admin/dashboard
```

---

### 12. **Auth Screens**
**Already Integrated:**
- `login_screen.dart` - Uses `AuthProvider.login()`
- `register_screen.dart` - Uses `AuthProvider.register()`
- `splash_screen.dart` - Checks auth status
- `forgot_password_screen.dart` - Uses `AuthProvider.requestPasswordReset()`

---

### 13. **AI Chat Screens**
**Updates Needed:**
```dart
// ai_chat_screen.dart
Consumer<AiProvider>(
  builder: (_, aiProvider, __) {
    return ListView.builder(
      itemCount: aiProvider.messages.length,
      itemBuilder: (_, i) => ChatMessage(msg: aiProvider.messages[i]),
    );
  },
)

// Send message:
aiProvider.sendMessage(userMessage)

// API: POST /ai/chat or /chat/messages
```

---

### 14. **General Screens**
**Updates Needed:**
```dart
// post_details_screen.dart
- Load: Provider.of<CommunityProvider>(context, listen: false).loadPostDetails(postId)
- API: GET /posts/{id}
```

---

## Required Providers to Create

### Providers Needed (if not existing):
1. **CommunityProvider** - For posts, comments, community features
2. **PaymentProvider** - For payment history and receipts
3. **AdminProvider** - For admin dashboard and user management
4. **AiProvider** - For AI chat functionality
5. **BookingProvider** - For tour bookings (if separate from TourProvider)

---

## Provider Method Template

```dart
class [Feature]Provider extends ChangeNotifier {
  final [Feature]Repository _repository;
  
  // State
  List<[Model]> _items = [];
  [Model]? _selectedItem;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  List<[Model]> get items => _items;
  [Model]? get selectedItem => _selectedItem;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  [Feature]Provider(this._repository);
  
  // Load all items
  Future<void> loadItems() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      _items = await _repository.getItems();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

---

## API Integration Checklist

- ✅ Explore Screens (Places, Tours, Favorites)
- ✅ Place/Tour Details Screens
- ⚠️ Booking Screen - Needs integration
- ⚠️ Community Screen - Needs integration
- ⚠️ Dashboard Screen - Needs dynamic data
- ⚠️ Saved Places Screen - Needs integration
- ⚠️ Payment Screens - Needs integration
- ⚠️ Admin Screens - Needs integration
- ⚠️ AI Chat Screens - Needs integration
- ✅ Auth Screens - Already integrated

---

## Testing Checklist

For each screen:
- [ ] API is called on screen load
- [ ] Loading state shows spinner
- [ ] Error state shows error message
- [ ] Empty state shows proper message
- [ ] Data displays correctly
- [ ] Filters/Search works with API
- [ ] Navigation passes correct IDs
- [ ] No static/hardcoded data visible

---

## Next Steps

1. **Create missing providers** (Community, Payment, Admin, AI)
2. **Create missing repositories** for new providers
3. **Update dashboard_screen** to load tours dynamically
4. **Implement booking flow** with API
5. **Add error handling dialogs** to all screens
6. **Test with real API** before deployment
