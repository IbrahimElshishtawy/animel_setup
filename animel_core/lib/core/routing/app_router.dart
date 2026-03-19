import 'package:animel_core/features/auth/presentation/welcome_auth_screen.dart';
import 'package:animel_core/features/home/presentation/animal_detail_screen.dart';
import 'package:animel_core/features/profile/presentation/contact_screen.dart';
import 'package:animel_core/features/profile/presentation/profile_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/animal_model.dart';
import '../../core/models/product_model.dart';
import '../../features/adoption/presentation/adoption_detail_screen.dart';
import '../../features/adoption/presentation/adoption_list_screen.dart';
import '../../features/auth/logic/auth_bloc.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/verify_email_screen.dart';
import '../../features/chat/presentation/chat_detail_screen.dart';
import '../../features/chat/presentation/chat_list_screen.dart';
import '../../features/donation/presentation/donation_screen.dart';
import '../../features/home/presentation/animal_list_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/maps/presentation/map_screen.dart';
import '../../features/onboarding/presentation/choose_language_screen.dart';
import '../../features/onboarding/presentation/permissions_info_screen.dart';
import '../../features/profile/presentation/add_pet_step1_screen.dart';
import '../../features/profile/presentation/edit_account_screen.dart';
import '../../features/profile/presentation/journey_setup_screen.dart';
import '../../features/profile/presentation/my_account_screen.dart';
import '../../features/profile/presentation/my_pets_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/report/presentation/report_step1_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/shop/presentation/product_detail_screen.dart';
import '../../features/shop/presentation/shop_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';

class AppRouter {
  static const _publicRoutes = {
    '/splash',
    '/choose-language',
    '/permissions-info',
    '/welcome-auth',
    '/login',
    '/register',
    '/verify-email',
  };

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final location = state.matchedLocation;
      final isPublicRoute = _publicRoutes.contains(location);

      if (authState is Unauthenticated) {
        return isPublicRoute ? null : '/welcome-auth';
      }

      if (authState is Authenticated &&
          !authState.hasCompletedJourney &&
          location != '/profile/journey') {
        return '/profile/journey';
      }

      if (authState is Authenticated && isPublicRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      _route(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      _route(
        path: '/choose-language',
        builder: (context, state) => const ChooseLanguageScreen(),
      ),
      _route(
        path: '/permissions-info',
        builder: (context, state) => const PermissionsInfoScreen(),
      ),
      _route(
        path: '/welcome-auth',
        builder: (context, state) => const WelcomeAuthScreen(),
      ),
      _route(path: '/login', builder: (context, state) => const LoginScreen()),
      _route(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      _route(
        path: '/verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      _route(path: '/home', builder: (context, state) => const HomeScreen()),
      _route(
        path: '/animal-list',
        builder: (context, state) => const AnimalListScreen(),
      ),
      _route(
        path: '/animal-details',
        builder: (context, state) {
          final animal = state.extra as Animal;
          return AnimalDetailScreen(animal: animal);
        },
      ),
      _route(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      _route(
        path: '/report',
        builder: (context, state) => const ReportStep1Screen(),
      ),
      _route(
        path: '/profile/language',
        builder: (context, state) => const ProfileLanguageScreen(),
      ),
      _route(
        path: '/profile/contact',
        builder: (context, state) => const ContactScreen(),
      ),
      _route(
        path: '/adopt',
        builder: (context, state) => const AdoptionListScreen(),
      ),
      _route(
        path: '/adoption-details',
        builder: (context, state) {
          final animal = state.extra as Animal;
          return AdoptionDetailScreen(animal: animal);
        },
      ),
      _route(path: '/shop', builder: (context, state) => const ShopScreen()),
      _route(
        path: '/product-details',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailScreen(product: product);
        },
      ),
      _route(path: '/map', builder: (context, state) => const MapScreen()),
      _route(
        path: '/chat',
        builder: (context, state) => const ChatListScreen(),
      ),
      _route(
        path: '/chat-detail',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? const {};
          return ChatDetailScreen(
            userName: extras['userName'] as String? ?? 'Animal Connect',
            userId: extras['userId'] as String? ?? '',
          );
        },
      ),
      _route(
        path: '/donation',
        builder: (context, state) => const DonationScreen(),
      ),
      _route(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      _route(
        path: '/profile/account',
        builder: (context, state) => const MyAccountScreen(),
      ),
      _route(
        path: '/profile/account/edit',
        builder: (context, state) => const EditAccountScreen(),
      ),
      _route(
        path: '/profile/journey',
        builder: (context, state) => const JourneySetupScreen(),
      ),
      _route(
        path: '/profile/pets',
        builder: (context, state) => const MyPetsScreen(),
      ),
      _route(
        path: '/profile/pets/add-step1',
        builder: (context, state) => const AddPetStep2Screen(),
      ),
    ],
  );

  static GoRoute _route({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        child: builder(context, state),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0.02),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
