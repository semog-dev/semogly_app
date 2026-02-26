import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/services/api_service.dart';

class AccountRepository extends ChangeNotifier implements IAccountRepository {
  final ApiService _apiService;

  bool _isUserLoggedIn = false;

  bool get isUserLoggedIn => _isUserLoggedIn;

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
      _isUserLoggedIn = true;
      notifyListeners();
    } on DioException catch (e) {
      _isUserLoggedIn = false;
      throw Exception(e);
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      await _apiService.dio.post('/account/refresh');
      _isUserLoggedIn = true;
      notifyListeners();
    } on DioException catch (e) {
      _isUserLoggedIn = false;
      throw Exception(e);
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      await _apiService.dio.get('/account/me');
      _isUserLoggedIn = true;
    } catch (e) {
      _isUserLoggedIn = false;
    }
    notifyListeners();
    return _isUserLoggedIn;
  }

  @override
  Future<void> logout() async {
    try {
      await _apiService.dio.post('/account/logout');
      _isUserLoggedIn = false;
      notifyListeners();
    } on DioException catch (e) {
      _isUserLoggedIn = false;
      throw Exception(e);
    }
  }

  @override
  Future<void> status() async {
    try {
      await _apiService.dio.get('/status');
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
