import 'package:flutter/material.dart';
import 'package:semogly_app/app/repositories/account_repository_impl.dart';
import 'package:semogly_app/core/inject/service_locator.dart';
import 'package:semogly_app/core/repositories/account_repository.dart';
import 'package:semogly_app/core/theme/app_styles.dart';
import 'package:semogly_app/core/widgets/action_card.dart';
import 'package:semogly_app/core/widgets/app_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountRepository = getIt<IAccountRepository>() as AccountRepository;

    return ListenableBuilder(
      listenable: accountRepository,
      builder: (context, child) {
        final String userName =
            accountRepository.currentAccount?.name ?? "Carregando...";

        return Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "Dashboard",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [_buildLogoutButton(accountRepository)],
          ),
          body: SingleChildScrollView(
            padding: AppStyles.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(userName: userName),

                const SizedBox(height: 32),

                const Text(
                  "Minhas Atividades",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Grade usando o componente reaproveitável ActionCard
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    ActionCard(
                      title: "Perfil",
                      icon: Icons.person_outline,
                      color: const Color(0xFF6366F1),
                      onTap: () => print("Ir para perfil"),
                    ),
                    ActionCard(
                      title: "Relatórios",
                      icon: Icons.bar_chart_rounded,
                      color: const Color(0xFFA855F7),
                      onTap: () => print("Ir para relatórios"),
                    ),
                    ActionCard(
                      title: "Configurações",
                      icon: Icons.settings_outlined,
                      color: Colors.blueGrey,
                      onTap: () => print("Ir para configurações"),
                    ),
                    ActionCard(
                      title: "Suporte",
                      icon: Icons.help_outline_rounded,
                      color: Colors.teal,
                      onTap: () async => await accountRepository.status(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton(IAccountRepository accountRepository) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.logout_rounded, color: Color(0xFFF87171)),
        onPressed: () async => await accountRepository.logout(),
      ),
    );
  }
}
