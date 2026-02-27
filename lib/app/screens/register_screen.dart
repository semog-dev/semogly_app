import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:semogly_app/core/inject/service_locator.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/widgets/app_text_field.dart';
import 'package:semogly_app/core/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final publicId = await getIt<IAccountRepository>().createAccount(
        firstname: _firstnameController.text,
        lastname: _lastnameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        context.push(
          '/verify-email',
          extra: {'publicId': publicId, 'email': _emailController.text},
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao registrar: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Criar Conta",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Preencha os dados abaixo",
                style: TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 32),

              AppTextField(
                controller: _firstnameController,
                hint: "Nome",
                icon: Icons.person_outlined,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _lastnameController,
                hint: "Sobrenome",
                icon: Icons.person_outlined,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _emailController,
                hint: "Email",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                hint: "Senha",
                icon: Icons.password_outlined,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _confirmPasswordController,
                hint: "Corfirme sua Senha",
                icon: Icons.password_outlined,
                isPassword: true,
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: "Registrar",
                isLoading: _isLoading,
                onPressed: _handleRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
