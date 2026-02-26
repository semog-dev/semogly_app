import 'package:get_it/get_it.dart';
import 'package:semogly_app/app/repositories/account_repository_impl.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/services/api_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final apiService = ApiService();
  await apiService.init();
  getIt.registerSingleton<ApiService>(apiService);
  final accountRepo = AccountRepository(apiService);
  getIt.registerSingleton<IAccountRepository>(accountRepo);
  apiService.addAuthInterceptor(accountRepo);
}
