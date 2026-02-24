import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/services/api_service.dart';

class AccountRepository extends ChangeNotifier implements IAccountRepository {
  final ApiService _apiService;

  Future<bool>? _authFuture;

  AccountRepository(this._apiService);
  @override
  Future<void> createAccount(String email, String password) {
    // TODO: implement createAccount
    throw UnimplementedError();
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await _apiService.dio.post(
        '/account/login',
        data: {'email': email, 'password': password},
      );
      _invalidateCache();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> refreshToken() {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future<bool> isAuthenticated() {
    _authFuture ??= _apiService.dio
        .get('/account/me')
        .then((_) => true)
        .catchError((_) => false);
    return _authFuture!;
  }

  @override
  Future<void> logout() async {
    try {
      await _apiService.dio.post('/account/logout');
      _invalidateCache();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  void _invalidateCache() {
    _authFuture = null;
    notifyListeners();
  }
}
