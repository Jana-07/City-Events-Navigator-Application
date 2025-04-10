import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/screens/event_list_screen.dart';
import 'package:navigator_app/screens/explore_screen.dart';
import 'package:navigator_app/screens/login/login_screen.dart';
import 'package:navigator_app/screens/profile_screen.dart';
import 'package:navigator_app/screens/admin_profile.dart';
import 'package:navigator_app/screens/navigation.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/screens/sign_up/sign_up_screen.dart';
import 'package:navigator_app/screens/splash_screem.dart';
import 'package:navigator_app/services/firebase_auth_repository.dart';
import 'package:navigator_app/services/first_launch_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_provider.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@riverpod
GoRouter goRouter(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);
  final firstLaunchAsync = ref.watch(firstLaunchProvider);

  if (!firstLaunchAsync.hasValue) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
          path: '/loading',
          builder: (context, state) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
      initialLocation: '/loading',
    );
  }

  final isFirstLaunch = firstLaunchAsync.value!;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: isFirstLaunch ? Routes.splashScreen : Routes.exploreScreen,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            Navigation(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settingScreen,
                builder: (context, state) => Container(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.eventsScreen,
                builder: (context, state) => Container(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.exploreScreen,
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profileScreen,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.adminpScreen,
                builder: (context, state) => const AdminProfile(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.registerScreen,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/event',
        builder: (context, state) {
          final title = state.uri.queryParameters['title'] ?? 'Events';
          final filter = state.uri.queryParameters['filter'] ?? 'all';
          return EventListScreen(title: title, initialFilter: filter);
        },
      ),
    ],
    redirect: (context, state) {
      final currentLocation = state.uri.toString();
      if (authState.valueOrNull == null &&
          currentLocation != Routes.splashScreen &&
          currentLocation != Routes.loginScreen &&
          currentLocation != Routes.registerScreen) {
        return Routes.splashScreen;
      } else if (authState.valueOrNull != null &&
          currentLocation == Routes.registerScreen) {
        return Routes.exploreScreen;
      }
      return null;
    },
  );
}
