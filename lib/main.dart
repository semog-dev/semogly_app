import 'package:flutter/material.dart';
import 'package:semogly_app/app/routes/app_router.dart';
import 'package:semogly_app/core/inject/service_locator.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/theme/app_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  final appRouter = AppRouter(getIt<IAccountRepository>());
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
