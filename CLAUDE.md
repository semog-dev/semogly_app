# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get        # Install dependencies
flutter run            # Run in debug mode
flutter test           # Run all tests
flutter test test/widget_test.dart  # Run a single test file
flutter analyze        # Static analysis
dart format .          # Format code
flutter clean          # Clean build artifacts
flutter build apk      # Build Android APK
flutter build web      # Build web
```

## Architecture

Flutter app following Clean Architecture with two main layers:

- **`lib/core/`** — Shared infrastructure: services, widgets, theme, interceptors, abstract repositories
- **`lib/app/`** — Feature code: screens, concrete repository implementations, models, routing

### Dependency Injection

GetIt service locator, initialized in `lib/core/inject/service_locator.dart` before `runApp`. All services are registered as singletons. Access via `getIt<Type>()`.

### Navigation

GoRouter (`lib/app/routes/app_router.dart`) with route guards that redirect based on auth state. The router takes `accountRepository` as `refreshListenable`, so auth changes automatically trigger route re-evaluation.

Routes: `/` (home), `/login`, `/register`, `/verify-email`

### HTTP / API

`ApiService` (`lib/core/services/api_service.dart`) wraps Dio with:
- `CookieManager` with `FileStorage` for persistent session cookies
- `AuthInterceptor` — silently refreshes token on 401 responses
- `LoadingService` interceptor — increments/decrements a counter to show/hide global loading overlay
- Error interceptor — maps errors to user-facing messages via `MessageService`

Base URL: `https://semogly-api.onrender.com/api`

### State Management

`ValueNotifier` / `ChangeNotifier` with `ListenableBuilder` — no Provider or Riverpod. `AccountRepository` extends `ChangeNotifier` and is the primary auth state source.

### Styling

All colors, text styles, borders, and gradients are centralized in `lib/core/theme/app_styles.dart`. Dark theme with indigo/purple gradient (`#6366F1` → `#A855F7`) on a dark blue-black background (`#0F172A`).

### Loading & Messages

- `LoadingService` — global loading overlay, reference-counted (supports nested async calls)
- `MessageService` — global snackbar display via `ScaffoldMessenger`; requires the navigator key set on `MaterialApp`

Both are displayed via a `ValueListenableBuilder` wrapping the router in `main.dart`.
