import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_shell.dart';
import '../widgets/page_scaffold.dart';

class AppRoutes {
  const AppRoutes._();

  static const dashboard = '/';
  static const schedule = '/schedule';
  static const bookings = '/bookings';
  static const patients = '/patients';
  static const account = '/account';

  static const session = '/session';
  static const patient = '/patient';

  static String sessionDetail(String id) => '$session/$id';
  static String patientDetail(String id) => '$patient/$id';
  static String bookingsTab(String tab) => '$bookings?tab=$tab';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const _Placeholder('Home'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.schedule,
                builder: (context, state) => const _Placeholder('Schedule'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bookings,
                builder: (context, state) => const _Placeholder('Bookings'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.patients,
                builder: (context, state) => const _Placeholder('Patients'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (context, state) => const _Placeholder('Account'),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.session}/:id',
        builder: (context, state) => const _Placeholder('Session'),
      ),
      GoRoute(
        path: '${AppRoutes.patient}/:id',
        builder: (context, state) => const _Placeholder('Patient'),
      ),
    ],
  );
});

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(title: title, child: const SizedBox.shrink());
  }
}
