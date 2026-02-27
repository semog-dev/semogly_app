import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:semogly_app/app/models/account_model.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/services/api_service.dart';

class AccountRepository extends ChangeNotifier implements IAccountRepository {
  final ApiService _apiService;

  Account? _currentAccount;
  Account? get currentAccount => _currentAccount;

  bool _isUserLoggedIn = false;

  bool get isUserLoggedIn => _isUserLoggedIn;

  AccountRepository(this._apiService);

  @override
  Future<void> login(String email, String password) async {
    await _apiService.dio.post(
      '/account/login',
      data: {'email': email, 'password': password},
    );
    _isUserLoggedIn = true;
    notifyListeners();
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
      final response = await _apiService.dio.get('/account/me');
      _isUserLoggedIn = true;
      _currentAccount = Account.fromJson(response.data);
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

  @override
  Future<String> createAccount({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/account',
        data: {
          'firstName': firstname,
          'lastName': lastname,
          'email': email,
          'password': password,
        },
      );
      return response.data['publicId'].toString();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> verifyEmail({
    required String publicId,
    required String verificationCode,
  }) async {
    try {
      await _apiService.dio.post(
        '/account/$publicId/verification',
        data: {'verificationCode': verificationCode},
      );
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
