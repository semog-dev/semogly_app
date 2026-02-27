import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semogly_app/core/inject/service_locator.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/theme/app_styles.dart';
import 'package:semogly_app/core/widgets/otp_field.dart';
import 'package:semogly_app/core/widgets/primary_button.dart';

class ActivationScreen extends StatefulWidget {
  final String publicId;
  final String email;

  const ActivationScreen({
    super.key,
    required this.publicId,
    required this.email,
  });

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String _currentCode = "";
  bool _isLoading = false;

  Future<void> _handleVerify(String code) async {
    if (code.length < 6) return;

    setState(() => _isLoading = true);
    try {
      await getIt<IAccountRepository>().verifyEmail(
        publicId: widget.publicId,
        verificationCode: code,
      );
      if (mounted) {
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("E-mail verificado com sucesso!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Código inválido ou expirado")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppStyles.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: AppStyles.screenPadding,
        child: Column(
          children: [
            const Icon(
              Icons.mark_email_read_outlined,
              size: 80,
              color: AppStyles.primary,
            ),
            const SizedBox(height: 32),
            const Text(
              "Verifique seu E-mail",
              style: TextStyle(
                color: AppStyles.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enviamos um código de 6 dígitos para:",
              style: TextStyle(color: AppStyles.textSecondary),
            ),
            Text(
              widget.email,
              style: const TextStyle(
                color: AppStyles.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            OtpField(
              onCompleted: (verifyCode) => _handleVerify(verifyCode),
              onChanged: (value) => _currentCode = value,
            ),

            const SizedBox(height: 40),
            PrimaryButton(
              text: "Verificar Código",
              isLoading: _isLoading,
              onPressed: () => _handleVerify(_currentCode),
            ),
          ],
        ),
      ),
    );
  }
}
