// lib/router.dart
import 'package:go_router/go_router.dart';
import 'package:steel_strength/pages/main_page.dart';
import 'package:steel_strength/pages/home_page.dart';
import 'package:steel_strength/pages/result_page.dart';
import 'package:steel_strength/pages/settings_page.dart';
import 'package:steel_strength/pages/shear_page.dart';
import 'package:steel_strength/pages/buckling_page.dart';
import 'package:steel_strength/pages/ltb_page.dart';
import 'package:steel_strength/pages/serviceability_page.dart';
import 'package:steel_strength/pages/interaction_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/bending',
      name: 'bending',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) {
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
    GoRoute(
      path: '/shear',
      name: 'shear',
      builder: (context, state) => const ShearPage(),
    ),
    GoRoute(
      path: '/buckling',
      name: 'buckling',
      builder: (context, state) => const BucklingPage(),
    ),
    GoRoute(
      path: '/ltb',
      name: 'ltb',
      builder: (context, state) => const LtbPage(),
    ),
    GoRoute(
      path: '/serviceability',
      name: 'serviceability',
      builder: (context, state) => const ServiceabilityPage(),
    ),
    GoRoute(
      path: '/interaction',
      name: 'interaction',
      builder: (context, state) => const InteractionPage(),
    ),
  ],
);
