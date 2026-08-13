import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/contacts/screens/contact_list_screen.dart';
import '../../features/contacts/screens/contact_detail_screen.dart';
import '../../features/contacts/screens/add_contact_screen.dart';
import '../../features/ledger/screens/add_transaction_screen.dart';
import '../../features/sales/screens/add_sale_screen.dart';
import '../../features/sales/screens/sales_list_screen.dart';
import '../../features/expenses/screens/add_expense_screen.dart';
import '../../features/import/screens/import_screen.dart';
import '../../features/export/screens/export_screen.dart';
import '../../features/subscription/screens/subscription_screen.dart';
import '../../features/subscription/screens/payment_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../widgets/main_shell.dart';

// Route names
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const otp = '/otp';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const contacts = '/contacts';
  static const contactDetail = '/contacts/:id';
  static const addContact = '/contacts/add';
  static const addTransaction = '/transaction/add';
  static const addSale = '/sales/add';
  static const salesList = '/sales';
  static const addExpense = '/expenses/add';
  static const import_ = '/import';
  static const export_ = '/export';
  static const subscription = '/subscription';
  static const payment = '/subscription/pay';
  static const reports = '/reports';
  static const settings = '/settings';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.otp ||
          state.matchedLocation == AppRoutes.onboarding;

      if (isSplash) return null;
      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      if (isLoggedIn && isAuthRoute) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (_, state) => OtpScreen(
          phone: state.uri.queryParameters['phone'] ?? '',
          email: state.uri.queryParameters['email'],
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      // Main shell with bottom nav
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.contacts,
            builder: (_, __) => const ContactListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (_, __) => const AddContactScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (_, state) =>
                    ContactDetailScreen(contactId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.salesList,
            builder: (_, __) => const SalesListScreen(),
          ),
          GoRoute(
            path: AppRoutes.reports,
            builder: (_, __) => const ReportsScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),
      // Modal/push routes
      GoRoute(
        path: AppRoutes.addTransaction,
        builder: (_, state) => AddTransactionScreen(
          contactId: state.uri.queryParameters['contactId'],
          direction: state.uri.queryParameters['direction'],
        ),
      ),
      GoRoute(
        path: AppRoutes.addSale,
        builder: (_, __) => const AddSaleScreen(),
      ),
      GoRoute(
        path: AppRoutes.addExpense,
        builder: (_, __) => const AddExpenseScreen(),
      ),
      GoRoute(
        path: AppRoutes.import_,
        builder: (_, __) => const ImportScreen(),
      ),
      GoRoute(
        path: AppRoutes.export_,
        builder: (_, __) => const ExportScreen(),
      ),
      GoRoute(
        path: AppRoutes.subscription,
        builder: (_, __) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: AppRoutes.payment,
        builder: (_, __) => const PaymentScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
