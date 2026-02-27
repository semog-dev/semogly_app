abstract class IAccountRepository {
  Future<String> createAccount({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  });
  Future<void> verifyEmail({
    required String publicId,
    required String verificationCode,
  });
  Future<void> login(String email, String password);
  Future<void> logout();
  Future<void> refreshToken();
  Future<bool> isAuthenticated();
  Future<void> status();
}
