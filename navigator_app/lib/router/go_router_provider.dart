import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:navigator_app/providers/first_launch_provider.dart';

import 'package:navigator_app/ui/screens/screens.dart';

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
          path: Routes.loading,
          builder: (context, state) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
      initialLocation: Routes.loading,
    );
  }

  final isFirstLaunch = firstLaunchAsync.value!;
  final isGuestUser = authState.value == null;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: isFirstLaunch ? Routes.splash : Routes.home,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            Navigation(navigationShell: navigationShell),
        branches: [
          //Setting Route
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ]),
          //Events Route
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.filters,
              builder: (context, state) => CreateEditEventScreen(),
            ),
          ]),
          //Explore Events Route
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const ExploreScreen(),
            ),
          ]),
          //Event Map Route (soon)
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.exploreSearch,
              builder: (context, state) => Container(),
            ),
          ]),
          //Profile Route
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.profile,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: Routes.adminCreate,
                  name: Routes.createEventName,
                  builder: (context, state) => const CreateEditEventScreen(),
                ),
                GoRoute(
                  path: Routes.adminEdit,
                  name: Routes.editEventName,
                  builder: (context, state) {
                    final eventId = state.pathParameters['eventId'] ?? '';
                    return CreateEditEventScreen(eventId: eventId);
                  },
                ),
              ],
            ),
          ]),
        ],
      ),
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: Routes.eventsList,
        name: Routes.eventListName,
        builder: (context, state) {
          final title = state.uri.queryParameters['title'] ?? 'Events';
          final filter = state.uri.queryParameters['filter'] ?? 'all';
          return EventListScreen(title: title, initialFilter: filter);
        },
      ),
      GoRoute(
        path: Routes.filters,
        builder: (context, state) => const FilterScreen(),
      ),
      GoRoute(
        path: Routes.eventDetails,
        name: Routes.eventDetailsName,
        builder: (context, state) {
          final eventId = state.pathParameters['eventId']!;
          return EventDetailsScreen(eventId: eventId);
        },
      ),
    ],
    redirect: (context, state) {
      final currentLocation = state.uri.toString();
      final isLoggedIn = authState.valueOrNull != null;

     // Define public routes
      final publicRoutes = [
        Routes.splash,
        Routes.login,
        Routes.register,
      ];
      
      // Define guest-accessible routes
      final guestAccessibleRoutes = [
        Routes.home,
        Routes.eventsList,
        Routes.eventDetails,
        Routes.filters,
        Routes.exploreSearch,
      ];
      
      // Check if current location is a public route
      final isPublicRoute = publicRoutes.any((route) => 
          currentLocation == route || currentLocation.startsWith(route));
      
      // Check if current location is a guest-accessible route
      final isGuestAccessibleRoute = guestAccessibleRoutes.any((route) => 
          currentLocation == route || currentLocation.startsWith(route));
      
      // Allow access to public routes regardless of authentication
      if (isPublicRoute) {
        return null;
      }
      
      // If user has chosen guest mode and is trying to access a guest-accessible route
      if (isGuestUser && isGuestAccessibleRoute) {
        return null;
      }
      
      // If logged in, don't allow access to login/register
      if (isLoggedIn && isPublicRoute) {
        return Routes.home;
      }
      
      // For all other cases, allow the navigation
      return null;
    },
  );
}

