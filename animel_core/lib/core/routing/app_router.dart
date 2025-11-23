import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Auth
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/verify_email_screen.dart';

// Home & Search
import '../../features/home/presentation/home_screen.dart';
import '../../features/search/presentation/search_screen.dart';

// Report
import '../../features/report/presentation/report_step1_screen.dart';
import '../../features/report/presentation/report_step2_screen.dart';

// Adopt & Donation
import '../../features/adoption/presentation/adopt_list_screen.dart';
import '../../features/donation/presentation/donation_screen.dart';

// Profile
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/my_account_screen.dart';
import '../../features/profile/presentation/edit_account_screen.dart';
import '../../features/profile/presentation/my_pets_screen.dart';
import '../../features/profile/presentation/add_pet_step1_screen.dart';
import '../../features/profile/presentation/add_pet_step2_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/login",
    routes: [
      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: "/register",
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: "/verify-email",
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(path: "/home", builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: "/search",
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: "/report",
        builder: (context, state) => const ReportStep1Screen(),
      ),
      GoRoute(
        path: "/report-step2",
        builder: (context, state) => const ReportStep2Screen(),
      ),
      GoRoute(
        path: "/adopt",
        builder: (context, state) => const AdoptListScreen(),
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
        builder: (context, state) => const AddPetStep1Screen(),
      ),
      GoRoute(
        path: "/profile/pets/add-step2",
        builder: (context, state) => const AddPetStep2Screen(),
      ),
    ],
  );
}
