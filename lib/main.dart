// 📁 lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/constants/app_colors.dart';
import 'core/services/api_service.dart';

// Auth
import 'features/auth/repositories/auth_repository.dart';
import 'features/auth/providers/auth_provider.dart';

// Tours
import 'features/tours/repositories/tour_repository.dart';
import 'features/tours/providers/tour_provider.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';

// Places
import 'features/places/repositories/place_repository.dart';
import 'features/places/providers/place_provider.dart';
import 'features/places/repositories/comment_repository.dart';
import 'features/places/providers/comment_provider.dart';
import 'features/places/repositories/conversation_repository.dart';
import 'features/places/providers/conversation_provider.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/user_selection_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/reset_password_screen.dart';

// Tourist
import 'screens/tourist/main_navigation.dart';
import 'screens/tourist/notifications_screen.dart';
import 'screens/tourist/edit_profile_screen.dart';
import 'screens/tourist/saved_places_screen.dart';

// Explore
import 'screens/explore/explore_screen.dart';
import 'screens/explore/place_details_screen.dart';
import 'screens/explore/tour_details_screen.dart';
import 'screens/explore/tours_screen.dart';
import 'screens/explore/booking_screen.dart';
import 'screens/explore/favorites_screen.dart';

// AI
import 'screens/ai/ai_chat_screen.dart';
import 'screens/ai/ai_plan_details_screen.dart';

// Payment
import 'screens/payment/payment_receipts_screen.dart';
import 'screens/payment/payment_success_screen.dart';
import 'screens/payment/payment_failed_screen.dart';

// Admin
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/approve_payments_screen.dart';
import 'screens/admin/create_new_tour_screen.dart';
import 'screens/admin/manage_tours_screen.dart';
import 'screens/admin/manage_users_screen.dart';

// General
import 'screens/general/community_screen.dart';
import 'screens/general/post_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AmunGuideApp());
}

class AmunGuideApp extends StatelessWidget {
  const AmunGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<ApiService>(create: (_) => ApiService()),
        
        // Repositories
        ProxyProvider<ApiService, AuthRepository>(
          update: (_, apiService, __) => AuthRepository(apiService),
        ),
        ProxyProvider<ApiService, PlaceRepository>(
          update: (_, apiService, __) => PlaceRepository(apiService),
        ),
        ProxyProvider<ApiService, TourRepository>(
          update: (_, apiService, __) => TourRepository(apiService),
        ),
        ProxyProvider<ApiService, CommentRepository>(
          update: (_, apiService, __) => CommentRepository(apiService),
        ),
        ProxyProvider<ApiService, ConversationRepository>(
          update: (_, apiService, __) => ConversationRepository(apiService),
        ),
        
        // Providers (State Management)
        ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthRepository>(),
          ),
          update: (_, authRepository, previousAuthProvider) =>
              previousAuthProvider ?? AuthProvider(authRepository),
        ),
        ChangeNotifierProxyProvider<PlaceRepository, PlaceProvider>(
          create: (context) => PlaceProvider(
            context.read<PlaceRepository>(),
          ),
          update: (_, placeRepository, previousPlaceProvider) =>
              previousPlaceProvider ?? PlaceProvider(placeRepository),
        ),
        ChangeNotifierProxyProvider<TourRepository, TourProvider>(
          create: (context) => TourProvider(
            context.read<TourRepository>(),
          ),
          update: (_, tourRepository, previousTourProvider) =>
              previousTourProvider ?? TourProvider(tourRepository),
        ),
        ChangeNotifierProxyProvider<CommentRepository, CommentProvider>(
          create: (context) => CommentProvider(
            context.read<CommentRepository>(),
          ),
          update: (_, commentRepository, previousCommentProvider) =>
              previousCommentProvider ?? CommentProvider(commentRepository),
        ),
        ChangeNotifierProxyProvider<ConversationRepository, ConversationProvider>(
          create: (context) => ConversationProvider(
            context.read<ConversationRepository>(),
          ),
          update: (_, conversationRepository, previousConversationProvider) =>
              previousConversationProvider ?? ConversationProvider(conversationRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amun Guide',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.bgDark,
          primaryColor: AppColors.gold,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.gold,
            surface: AppColors.bgCard,
          ),
        ),
        home: const SplashScreen(),
        routes: {

          // ══════════════════════════════════════
          // AUTH
          // splash → onboarding → welcome → user_selection
          //       → login → home
          //       → register → home
          //       → forgot_password → reset_password → login
          // ══════════════════════════════════════
          '/splash':          (ctx) => const SplashScreen(),
          '/onboarding':      (ctx) => const OnboardingScreen(),
          '/welcome':         (ctx) => const WelcomeScreen(),
          '/user-selection':  (ctx) => const UserSelectionScreen(),
          '/login':           (ctx) => const LoginScreen(),
          '/register':        (ctx) => const RegisterScreen(),
          '/forgot-password': (ctx) => ForgotPasswordScreen(),
          '/reset-password':  (ctx) => ResetPasswordScreen(),

          // ══════════════════════════════════════
          // MAIN APP
          // ══════════════════════════════════════
          '/home':            (ctx) => const MainNavigation(),

          // ══════════════════════════════════════
          // TOURIST
          // ══════════════════════════════════════
          '/notifications':   (ctx) => const NotificationsScreen(),
          '/edit-profile':    (ctx) => const EditProfileScreen(),
          '/saved-places':    (ctx) => const SavedPlacesScreen(),

          // ══════════════════════════════════════
          // EXPLORE
          // ══════════════════════════════════════
          '/explore':         (ctx) => const ExploreScreen(),
          '/place-details':   (ctx) => const PlaceDetailsScreen(),
          '/tours':           (ctx) => const ToursScreen(),
          '/tour-details':    (ctx) => const TourDetailsScreen(),
          '/booking':         (ctx) => BookingScreen(
            tourId: ModalRoute.of(ctx)?.settings.arguments as int? ?? 0,
          ),
          '/favorites':       (ctx) => const FavoritesScreen(),

          // ══════════════════════════════════════
          // AI — يتضاف في Section 4
          // ══════════════════════════════════════
          '/ai-chat':         (ctx) => const AiChatScreen(),
          '/ai-plan-details': (ctx) => const AiPlanDetailsScreen(),

          // ══════════════════════════════════════
          // PAYMENT — يتضاف في Section 5
          // ══════════════════════════════════════
          '/payment-receipts': (ctx) => const PaymentReceiptsScreen(),
          '/payment-success':  (ctx) => const PaymentSuccessScreen(),
          '/payment-failed':   (ctx) => const PaymentFailedScreen(),

          // ══════════════════════════════════════
          // ADMIN — يتضاف في Section 6
          // ══════════════════════════════════════
          '/admin':            (ctx) => const AdminDashboardScreen(),
          '/approve-payments': (ctx) => const ApprovePaymentsScreen(),
          '/create-tour':      (ctx) => const CreateNewTourScreen(),
          '/manage-tours':     (ctx) => const ManageToursScreen(),
          '/manage-users':     (ctx) => const ManageUsersScreen(),

          // ══════════════════════════════════════
          // GENERAL — يتضاف في Section 7
          // ══════════════════════════════════════
          '/community':     (ctx) => const CommunityScreen(),
          '/post-details':  (ctx) => const PostDetailsScreen(),
        },
      ),
    );
  }
}