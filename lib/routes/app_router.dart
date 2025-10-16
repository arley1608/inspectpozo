import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/new_project_screen.dart';
import '../screens/active_projects_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/projects/new',
      builder: (_, __) => const NewProjectScreen(),
    ),
    GoRoute(
      path: '/projects/active',
      builder: (_, __) => const ActiveProjectsScreen(),
    ),
  ],
  // nada de redirects que puedan hacer bucles
);
