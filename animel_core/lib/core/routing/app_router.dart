import 'package:go_router/go_router.dart';

// Screens (placeholder – actual paths added later)
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/login",
    routes: [
      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
      GoRoute(path: "/home", builder: (context, state) => const HomeScreen()),
    ],
  );
}
