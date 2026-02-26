import 'package:flutter/material.dart';

class AppStyles {
  // --- Paleta de Cores ---
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFFA855F7);
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Colors.blueGrey;
  static const Color error = Color(0xFFF87171);

  // --- Gradientes ---
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Estilos de Texto ---
  static const TextStyle title = TextStyle(
    color: textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    color: textSecondary,
    fontSize: 16,
  );

  static const TextStyle buttonText = TextStyle(
    color: textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // --- Bordas ---
  static BorderRadius borderRadius = BorderRadius.circular(16);

  static const EdgeInsets screenPadding = EdgeInsets.all(24.0);
}
