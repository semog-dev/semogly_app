import 'package:flutter/material.dart';
import 'package:semogly_app/app/repositories/account_repository_impl.dart';
import 'package:semogly_app/app/routes/app_router.dart';
import 'package:semogly_app/core/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  await apiService.init();
  final accountRepository = AccountRepository(apiService);
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
    );
  }
}
