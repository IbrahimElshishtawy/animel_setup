import 'package:animel_core/features/auth/presentation/welcome_auth_screen.dart';
import 'package:animel_core/features/home/presentation/animal_detail_screen.dart';
import 'package:animel_core/features/profile/presentation/contact_screen.dart';
import 'package:animel_core/features/profile/presentation/profile_language_screen.dart';
import 'package:go_router/go_router.dart';

// ONBOARDING
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/choose_language_screen.dart';
import '../../features/onboarding/presentation/permissions_info_screen.dart';

// AUTH
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/verify_email_screen.dart';

// HOME & OTHERS
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/animal_list_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/report/presentation/report_step1_screen.dart';
import '../../features/adoption/presentation/adoption_list_screen.dart';
import '../../features/adoption/presentation/adoption_detail_screen.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../features/shop/presentation/product_detail_screen.dart';
import '../../features/maps/presentation/map_screen.dart';
import '../../features/chat/presentation/chat_list_screen.dart';
import '../../features/chat/presentation/chat_detail_screen.dart';
import '../../features/donation/presentation/donation_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/my_account_screen.dart';
import '../../features/profile/presentation/edit_account_screen.dart';
import '../../features/profile/presentation/my_pets_screen.dart';
import '../../features/profile/presentation/add_pet_step1_screen.dart';

import '../../core/models/animal_model.dart';
import '../../core/models/product_model.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/splash",
    routes: [
      // ONBOARDING
      GoRoute(
        path: "/splash",
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: "/choose-language",
        builder: (context, state) => const ChooseLanguageScreen(),
      ),
      GoRoute(
        path: "/permissions-info",
        builder: (context, state) => const PermissionsInfoScreen(),
      ),
      GoRoute(
        path: "/welcome-auth",
        builder: (context, state) => const WelcomeAuthScreen(),
      ),

      // AUTH
      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: "/register",
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: "/verify-email",
        builder: (context, state) => const VerifyEmailScreen(),
      ),

      // MAIN
      GoRoute(path: "/home", builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: "/animal-list",
        builder: (context, state) => const AnimalListScreen(),
      ),
      GoRoute(
        path: "/animal-details",
        builder: (context, state) {
          final animal = state.extra as Animal;
          return AnimalDetailScreen(animal: animal);
        },
      ),
      GoRoute(
        path: "/search",
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: "/report",
        builder: (context, state) => const ReportStep1Screen(),
      ),
      GoRoute(
        path: "/profile/language",
        builder: (context, state) => const ProfileLanguageScreen(),
      ),
      GoRoute(
        path: "/profile/contact",
        builder: (context, state) => const ContactScreen(),
      ),

      GoRoute(
        path: "/adopt",
        builder: (context, state) => const AdoptionListScreen(),
      ),
      GoRoute(
        path: "/adoption-details",
        builder: (context, state) {
          final animal = state.extra as Animal;
          return AdoptionDetailScreen(animal: animal);
        },
      ),
      GoRoute(
        path: "/shop",
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: "/product-details",
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        path: "/map",
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: "/chat",
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: "/chat-detail",
        builder: (context, state) {
          final userName = state.extra as String;
          return ChatDetailScreen(userName: userName);
        },
      ),
      GoRoute(
        path: "/donation",
        builder: (context, state) => const DonationScreen(),
      ),
      GoRoute(
        path: "/profile",
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: "/profile/account",
        builder: (context, state) => const MyAccountScreen(),
      ),
      GoRoute(
        path: "/profile/account/edit",
        builder: (context, state) => const EditAccountScreen(),
      ),
      GoRoute(
        path: "/profile/pets",
        builder: (context, state) => const MyPetsScreen(),
      ),
      GoRoute(
        path: "/profile/pets/add-step1",
        builder: (context, state) => const AddPetStep2Screen(),
      ),
    ],
  );
}
