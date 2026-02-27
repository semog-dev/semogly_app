import 'package:get_it/get_it.dart';
import 'package:semogly_app/app/repositories/account_repository_impl.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/services/api_service.dart';
import 'package:semogly_app/core/services/loading_service.dart';
import 'package:semogly_app/core/services/message_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<MessageService>(MessageService());
  getIt.registerSingleton<LoadingService>(LoadingService());

  final apiService = ApiService();
  getIt.registerSingleton<ApiService>(apiService);

  getIt.registerSingleton<IAccountRepository>(
    AccountRepository(getIt<ApiService>()),
  );

  await apiService.init();
}
