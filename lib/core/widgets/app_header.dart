import 'package:flutter/material.dart';
import '../../core/theme/app_styles.dart';

class AppHeader extends StatelessWidget {
  final String userName;
  final String subtitle;

  const AppHeader({
    super.key,
    required this.userName,
    this.subtitle = "Tudo pronto por aqui.",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppStyles.screenPadding, // Usando sua constante de padding
      decoration: BoxDecoration(
        gradient:
            AppStyles.primaryGradient, // Usando seu gradiente centralizado
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppStyles.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Olá, $userName!",
                  style: AppStyles.title.copyWith(
                    fontSize: 22,
                  ), // Reaproveitando e ajustando o título
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Um avatar circular elegante
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}
