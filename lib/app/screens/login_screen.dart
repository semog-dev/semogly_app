import 'package:flutter/material.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';

class LoginScreen extends StatefulWidget {
  final IAccountRepository accountRepository;
  const LoginScreen({super.key, required this.accountRepository});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Dica: adicione um loading

  void _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      // 2. Use o serviço que veio do widget (o mesmo que o GoRouter ouve)
      await widget.accountRepository.login(
        _emailController.text,
        _passwordController.text,
      );
      // O GoRouter fará o redirecionamento automático daqui!
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}
