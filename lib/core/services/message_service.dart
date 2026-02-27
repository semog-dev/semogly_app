import 'package:flutter/material.dart';
import 'package:semogly_app/core/theme/app_styles.dart';

class MessageService {
  // Chave global para acessar o ScaffoldMessenger sem context
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showError(String message) {
    _showSnackBar(
      message: message,
      backgroundColor: Colors.redAccent,
      icon: Icons.error_outline,
    );
  }

  void onSuccess(String message) {
    _showSnackBar(
      message: message,
      backgroundColor: Colors.green.shade700,
      icon: Icons.check_circle_outline,
    );
  }

  void _showSnackBar({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    messengerKey.currentState?.clearSnackBars(); // Remove a anterior se houver
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
