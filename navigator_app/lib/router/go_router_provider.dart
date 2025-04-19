import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/event_data.dart';
import 'package:navigator_app/data/models/event.dart';
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
              path: Routes.events,
              builder: (context, state) => CreateEditEventScreen(),
            ),
          ]),
          //Explore Events Route
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const ExploreScreen(),
              routes: [
                // GoRoute(
                //   path: Routes.exploreDetails,
                //   name: Routes.eventDetailsName,
                //   builder: (context, state) {
                //     final eventId = state.pathParameters['eventId'] ?? '';
                //     final event = dummyEvents.firstWhere(
                //       (e) => e.id == eventId,
                //       orElse: () => dummyEvents.first,
                //     );
                //     return EventDetailsScreen(event: event);
                //   },
                // ),
              ],
            ),
          ]),
          //Event Map Route (soon)
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.profile,
              builder: (context, state) => Container(),
            ),
          ]),
          //Profile Route
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.admin,
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
        path: Routes.eventList,
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
          final event = state.extra as Event;
          return EventDetailsScreen(event: event);
        },
      ),
    ],
    redirect: (context, state) {
      final currentLocation = state.uri.toString();
      final isLoggedIn = authState.valueOrNull != null;

      if (!isLoggedIn &&
          currentLocation != Routes.splash &&
          currentLocation != Routes.login &&
          currentLocation != Routes.register) {
        return Routes.splash;
      }

      if (isLoggedIn &&
          (currentLocation == Routes.login ||
              currentLocation == Routes.register)) {
        return Routes.home;
      }

      return null;
    },
  );
}
