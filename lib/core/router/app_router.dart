import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/screens/account_screen.dart';
import '../../features/account/presentation/screens/edit_profile_screen.dart';
import '../../features/account/presentation/screens/language_screen.dart';
import '../../features/account/presentation/screens/my_profile_screen.dart';
import '../../features/bookings/presentation/screens/bookings_screen.dart';
import '../../features/complaints/presentation/screens/my_complaints_screen.dart';
import '../../features/complaints/presentation/screens/report_issue_screen.dart';
import '../../features/bookings/presentation/screens/session_detail_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/patients/presentation/screens/patient_detail_screen.dart';
import '../../features/patients/presentation/screens/patients_list_screen.dart';
import '../../features/home/presentation/screens/dashboard_screen.dart';
import '../../features/schedule/presentation/screens/schedule_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const dashboard = '/';
  static const schedule = '/schedule';
  static const bookings = '/bookings';
  static const patients = '/patients';
  static const account = '/account';

  static const myProfile = '/account/profile';
  static const editProfile = '/account/edit';
  static const language = '/account/language';
  static const reportIssue = '/account/report-issue';
  static const myComplaints = '/account/complaints';

  static const session = '/session';
  static const patient = '/patient';

  static String sessionDetail(String id) => '$session/$id';
  static String patientDetail(String id) => '$patient/$id';
  static String bookingsTab(String tab) => '$bookings?tab=$tab';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
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
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.schedule,
                builder: (context, state) => const ScheduleScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bookings,
                builder: (context, state) => BookingsScreen(
                  initialTab: state.uri.queryParameters['tab'],
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.patients,
                builder: (context, state) => const PatientsListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.myProfile,
        builder: (context, state) => const MyProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.reportIssue,
        builder: (context, state) => const ReportIssueScreen(),
      ),
      GoRoute(
        path: AppRoutes.myComplaints,
        builder: (context, state) => const MyComplaintsScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.session}/:id',
        builder: (context, state) =>
            SessionDetailScreen(sessionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '${AppRoutes.patient}/:id',
        builder: (context, state) =>
            PatientDetailScreen(patientId: state.pathParameters['id']!),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
