import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semogly_app/app/repositories/account_repository_impl.dart';
import 'package:semogly_app/app/screens/activation_screen.dart';
import 'package:semogly_app/app/screens/home_screen.dart';
import 'package:semogly_app/app/screens/login_screen.dart';
import 'package:semogly_app/app/screens/register_screen.dart';
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
      final bool goingToRegister = state.matchedLocation == '/register';
      final bool goingToVerify = state.matchedLocation == '/verify-email';

      if (!loggedIn && !goingToLogin && !goingToRegister && !goingToVerify)
        return '/login';
      if (loggedIn && (goingToLogin || goingToRegister || goingToVerify))
        return '/';

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen() /*ActivationScreen(
          publicId: 'ae7b7a60-907c-40cd-bd80-894d3f74f717',
          email: 'semogdev.pereira@hotmail.com',
        ),*/,
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return ActivationScreen(
            publicId: data['publicId'],
            email: data['email'],
          );
        },
      ),
    ],
  );
}
