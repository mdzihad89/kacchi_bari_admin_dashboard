
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kacchi_bari_admin_dashboard/features/auth/presentation/screens/login_screen.dart';
import 'package:kacchi_bari_admin_dashboard/features/branch/presentation/screen/branch_screen.dart';
import 'package:kacchi_bari_admin_dashboard/features/category/presentation/screen/category_screen.dart';
import 'package:kacchi_bari_admin_dashboard/features/employee/presentation/screen/employee_screen.dart';
import 'package:kacchi_bari_admin_dashboard/features/home_page/home_screen.dart';
import 'package:kacchi_bari_admin_dashboard/features/prodduct/presentation/screen/product_screen.dart';
import '../../features/dashboard/presentation/screen/dashboard_screen.dart';
import '../../features/order/order_screen.dart';
import '../common/error_page.dart';
import 'app_prefs.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();


class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: "/login",
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/dashboard",
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/employee",
                builder: (context, state) => const EmployeeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/branch",
                builder: (context, state) => const BranchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/category",
                builder: (context, state) => const CategoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/food",
                builder: (context, state) => const ProductScreen(),
              ),
            ],
          ),


          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/order",
                builder: (context, state) => const OrderScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
          path: '/login',
          builder: (context, state) {
            return const LoginScreen();
          }),
      GoRoute(
        path: '/404',
        builder: (BuildContext context, GoRouterState state) {
          return ErrorPage(error: state.extra as String? ?? '');
        },
      ),
    ],

      redirect: (context, state) async {
        final appPreferences = GetIt.instance<AppPreferences>();
        final token = appPreferences.getCredential();

        final isLoggingIn = state.matchedLocation == '/login';

        if (token == null) {
          return isLoggingIn ? null : '/login';
        }

        if (isLoggingIn) {
          return '/dashboard';
        }

        return null;
      },
    // debugLogDiagnostics: true,
    // onException: (context, state, router) {
    //   router.go('/404', extra: state.uri.toString());
    // },
    errorBuilder: (context, state) => ErrorPage(
      error: state.error!.message,
    ),
  );
}
