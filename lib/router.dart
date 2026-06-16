// lib/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:steel_strength/pages/home_page.dart';
import 'package:steel_strength/pages/result_page.dart';
import 'package:steel_strength/pages/settings_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) {
        // Expecting arguments via extra map
        final args = state.extra as Map<String, dynamic>? ?? {};
        return ResultPage(
          section: args['section'],
          designMoment: args['designMoment'],
          capacity: args['capacity'],
          utilization: args['utilization'],
        );
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
