import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semogly_app/app/repositories/account_repository_impl.dart';
import 'package:semogly_app/app/screens/home_screen.dart';
import 'package:semogly_app/app/screens/login_screen.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';

class AppRouter {
  final IAccountRepository accountRepository;

  AppRouter(this.accountRepository);

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: accountRepository as Listenable,

    redirect: (context, state) async {
      final bool loggedIn =
          (accountRepository as AccountRepository).isUserLoggedIn;
      final bool goingToLogin = state.matchedLocation == '/login';

      if (!loggedIn && !goingToLogin) return '/login';
      if (loggedIn && goingToLogin) return '/';

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ],
  );
}
