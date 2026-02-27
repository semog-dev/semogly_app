import 'package:flutter/material.dart';
import 'package:semogly_app/core/inject/service_locator.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/theme/app_styles.dart';
import 'package:semogly_app/core/widgets/app_text_field.dart';
import 'package:semogly_app/core/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final accountRepository = getIt<IAccountRepository>();

  void _handleLogin() async {
    try {
      await accountRepository.login(
        _emailController.text,
        _passwordController.text,
      );
      await accountRepository.isAuthenticated();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppStyles.screenPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_person_rounded,
                  size: 80,
                  color: Color(0xFF6366F1),
                ),
                const SizedBox(height: 32),

                const Text(
                  "Bem-vindo de volta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Acesse sua conta para continuar",
                  style: TextStyle(color: Colors.blueGrey),
                ),

                const SizedBox(height: 40),
                AppTextField(
                  controller: _emailController,
                  hint: "Email",
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  hint: "Senha",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 32),
                PrimaryButton(text: "Entrar", onPressed: _handleLogin),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Não tem uma conta? ",
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/register'),
                      child: const Text(
                        "Cadastre-se",
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
