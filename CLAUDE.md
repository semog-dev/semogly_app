# CLAUDE.md

Este arquivo fornece orientações ao Claude Code (claude.ai/code) ao trabalhar com o código deste repositório.

## Comandos

```bash
flutter pub get        # Instalar dependências
flutter run            # Rodar em modo debug
flutter test           # Rodar todos os testes
flutter test test/widget_test.dart  # Rodar um arquivo de teste específico
flutter analyze        # Análise estática
dart format .          # Formatar código
flutter clean          # Limpar artefatos de build
flutter build apk      # Build Android APK
flutter build web      # Build web
```

## Arquitetura

Aplicativo Flutter seguindo Clean Architecture com duas camadas principais:

- **`lib/core/`** — Infraestrutura compartilhada: services, widgets, theme, interceptors, repositórios abstratos
- **`lib/app/`** — Código de feature: screens, implementações concretas de repositórios, models, roteamento

### Injeção de Dependência

GetIt service locator, inicializado em `lib/core/inject/service_locator.dart` antes do `runApp`. Todos os serviços são registrados como singletons. Acesso via `getIt<Tipo>()`.

### Navegação

GoRouter (`lib/app/routes/app_router.dart`) com route guards que redirecionam com base no estado de autenticação. O router recebe `accountRepository` como `refreshListenable`, então mudanças de auth disparam automaticamente a reavaliação das rotas.

Rotas: `/` (home), `/login`, `/register`, `/verify-email`

### HTTP / API

`ApiService` (`lib/core/services/api_service.dart`) encapsula o Dio com:
- `CookieManager` com `FileStorage` para cookies de sessão persistentes
- `AuthInterceptor` — renova o token silenciosamente em respostas 401
- Interceptor do `LoadingService` — incrementa/decrementa um contador para exibir/ocultar o loading global
- Interceptor de erros — mapeia erros para mensagens ao usuário via `MessageService`

URL base: `https://semogly-api.onrender.com/api`

### Gerenciamento de Estado

`ValueNotifier` / `ChangeNotifier` com `ListenableBuilder` — sem Provider ou Riverpod. `AccountRepository` estende `ChangeNotifier` e é a principal fonte de estado de autenticação.

### Estilização

Todas as cores, estilos de texto, bordas e gradientes estão centralizados em `lib/core/theme/app_styles.dart`. Tema escuro com gradiente índigo/roxo (`#6366F1` → `#A855F7`) sobre fundo azul-escuro (`#0F172A`).

### Loading & Mensagens

- `LoadingService` — overlay de loading global, com contagem de referências (suporta chamadas assíncronas aninhadas)
- `MessageService` — exibição global de snackbars via `ScaffoldMessenger`; requer a navigator key configurada no `MaterialApp`

Ambos são exibidos via `ValueListenableBuilder` que envolve o router em `main.dart`.
