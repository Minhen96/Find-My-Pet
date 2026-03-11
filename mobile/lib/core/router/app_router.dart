import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/posts/data/models/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../layout/main_layout.dart';
import '../../features/posts/presentation/pages/community_feed_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/posts/presentation/pages/create_post_page.dart';
import '../../features/posts/presentation/pages/location_picker_page.dart';
import '../../features/posts/presentation/pages/post_details_page.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  // Listen to the auth state to trigger redirects when login/logout happens
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final isAuth = authState.value != null; // User is logged in
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) return '/dashboard';

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/create-post',
        builder: (context, state) => const CreatePostPage(),
      ),
      GoRoute(
        path: '/location-picker',
        builder: (context, state) => const LocationPickerPage(),
      ),
      GoRoute(
        path: '/post-details',
        builder: (context, state) {
          final post = state.extra as Post;
          return PostDetailsPage(post: post);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Wrap the navigation shell in our MainLayout scaffold
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Community Feed
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const CommunityFeedPage(),
              ),
            ],
          ),
          // Branch 1: Map
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                builder: (context, state) => const MapPage(),
              ),
            ],
          ),
          // Branch 2: Alerts
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/alerts',
                builder: (context, state) => const AlertsPage(),
              ),
            ],
          ),
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
