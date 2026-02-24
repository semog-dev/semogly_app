abstract class IAccountRepository {
  Future<void> createAccount(String email, String password);
  Future<void> login(String email, String password);
  Future<void> logout();
  Future<void> refreshToken();
  Future<bool> isAuthenticated();
}
