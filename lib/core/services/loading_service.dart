import 'package:flutter/material.dart';

class LoadingService {
  final ValueNotifier<int> _loadingCount = ValueNotifier(0);
  ValueNotifier<bool> get isLoading => ValueNotifier(_loadingCount.value > 0);

  void show() {
    _loadingCount.value++;
    _isLoadingNotifier.value = true;
  }

  void hide() {
    if (_loadingCount.value > 0) {
      _loadingCount.value--;
    }
    _isLoadingNotifier.value = _loadingCount.value > 0;
  }

  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(false);
  ValueNotifier<bool> get loadingNotifier => _isLoadingNotifier;
}
