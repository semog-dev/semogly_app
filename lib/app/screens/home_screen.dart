import 'package:flutter/material.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.accountRepository});
  final IAccountRepository accountRepository;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  void _handleLogout() async {
    setState(() => _isLoading = true);

    try {
      await widget.accountRepository.logout();
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
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogout,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Sair"),
            ),
          ],
        ),
      ),
    );
  }
}
