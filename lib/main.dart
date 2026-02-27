import 'package:flutter/material.dart';
import 'package:semogly_app/app/routes/app_router.dart';
import 'package:semogly_app/core/inject/service_locator.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/services/loading_service.dart';
import 'package:semogly_app/core/services/message_service.dart';
import 'package:semogly_app/core/theme/app_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  getIt.get<IAccountRepository>().isAuthenticated();
  final appRouter = AppRouter(getIt<IAccountRepository>());
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: getIt<MessageService>().messengerKey,
      title: 'Semogly App',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.router,
      // O segredo está aqui: o builder envolve o navegador do Router
      builder: (context, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: getIt<LoadingService>().loadingNotifier,
          builder: (context, isLoading, _) {
            return Stack(
              children: [
                ?child,
                if (isLoading)
                  AbsorbPointer(
                    child: Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppStyles.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
