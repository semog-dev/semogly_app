import 'package:flutter/material.dart';
import 'package:semogly_app/app/repositories/account_repository_impl.dart';
import 'package:semogly_app/app/routes/app_router.dart';
import 'package:semogly_app/core/services/api_service.dart';
import 'package:semogly_app/core/theme/app_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  await apiService.init();
  final accountRepository = AccountRepository(apiService);
  await accountRepository.isAuthenticated();
  apiService.addAuthInterceptor(accountRepository);
  final appRouter = AppRouter(accountRepository);
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.router,
      title: 'Semogly App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppStyles.background,
        primaryColor: AppStyles.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppStyles.primary,
          secondary: AppStyles.secondary,
          surface: AppStyles.surface,
          error: AppStyles.error,
        ),
      ),
    );
  }
}
