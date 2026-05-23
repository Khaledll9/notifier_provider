<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.9+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.9+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Riverpod-2.5-764ABC?style=for-the-badge&logo=flutter&logoColor=white" alt="Riverpod">
  <img src="https://img.shields.io/badge/State_Management-Riverpod_Notifier-6DB33F?style=for-the-badge" alt="Riverpod Notifier">
  <img src="https://img.shields.io/badge/license-MIT-blue?style=for-the-badge" alt="MIT License">
</p>

<br>

<div align="center">
  <!-- App mockup placeholder — replace with actual screenshots -->
  <img src="https://via.placeholder.com/320x640/1a1a2e/e94560?text=Notifier+Provider" alt="App Preview" width="240"/>
  &nbsp;&nbsp;
  <img src="https://via.placeholder.com/320x640/16213e/0f3460?text=State+Patterns" alt="State Patterns" width="240"/>
</div>

<br>

# 🧩 NotifierProvider

**Five idiomatic Riverpod state management patterns — built side-by-side in a single Flutter application.**

A practical, hands-on reference that demonstrates how to model asynchronous state using `NotifierProvider` with `@freezed` data classes, Dart `sealed class` hierarchies, and plain values. Each pattern is fully self-contained, making this the ideal playground for learning, comparing, and adopting Riverpod in production-grade Flutter apps.

---

## 📖 About The Project

State management is the backbone of any non-trivial Flutter application. NotifierProvider bridges the gap between simple `StateProvider` and full-blown async `AsyncNotifier` by giving you a mutable, lifecycle-aware notifier with full access to the Riverpod ecosystem.

This project explores **four concrete state-modelling strategies** — enum-based with `@freezed`, enum-based with async fetch in `build()`, sealed-class hierarchies, and sealed-class with async fetch in `build()` — along with a classic counter baseline. Every example hits a real HTTP API ([Bored API](https://www.boredapi.com/)), handles loading, success, and error states, and is intentionally wired to fail every other call so you can verify error-handling UI without a network toggle.

**Who this is for:**
- Flutter developers evaluating state-management approaches for a new project
- Teams standardising on Riverpod who need a shareable, executable style guide
- Hiring managers reviewing a structured, testable, production-like Flutter codebase
- Open-source contributors looking to extend or port patterns to their own apps

---

## 🛠 Tech Stack & Core Ecosystem

| Technology | Role in the Project |
|---|---|
| **Flutter** (SDK ^3.9) | Cross-platform UI framework — rendering on Android, iOS, Web, Windows, macOS, Linux |
| **Dart** (^3.9) | Type-safe language with sealed classes and pattern matching leveraged for state modelling |
| **Riverpod** (`flutter_riverpod` ^2.5) | Compile-safe, testable state management — the backbone of every page's architecture |
| **Riverpod Annotations** (`riverpod_annotation` + `riverpod_generator` ^2.4) | Code-gen powered `@riverpod` syntax — eliminates boilerplate and runtime errors |
| **Freezed** (`freezed_annotation` ^2.4 + `freezed` ^2.5) | Immutable data classes with `copyWith`, JSON serialisation, and exhaustive pattern matching |
| **Dio** (^5.9) | HTTP client with interceptor support — single shared instance configured via a Riverpod provider |
| **JSON Serializable** (`json_serializable` ^6.8) | Compile-time JSON mapping for the `Activity` model |
| **Build Runner** (`build_runner` ^2.4) | Code generation orchestrator — run after every `@riverpod` or `@freezed` edit |
| **Custom Lint** (`custom_lint` + `riverpod_lint`) | Riverpod-aware lint rules — catches provider misuse and stale dependencies at analysis time |
| **Device Preview Plus** (`device_preview_plus` ^2.1) | Device frame simulation for development and demo recordings |

---

## 🏗 Key Architecture

The project follows a **Feature-first directory layout**. Each page is a completely isolated module containing its own provider, state definition, and UI — sharing only the `Activity` model and the `Dio` provider. There are no global managers, no service locators, and no inheritance chains.

```
┌──────────────────────────────────────────────────────┐
│                    Presentation                       │
│  ┌──────────┐  ┌──────────────┐  ┌────────────────┐ │
│  │  Counter  │  │ EnumActivity │  │ SealedActivity │…│
│  │  Page     │  │  Page        │  │  Page          │ │
│  └────┬─────┘  └──────┬───────┘  └───────┬────────┘ │
│       │               │                  │           │
├───────┴───────────────┴──────────────────┴──────────┤
│                  Providers (Riverpod)                 │
│  ┌─────────────────────┐  ┌──────────────────────┐  │
│  │  CounterNotifier    │  │  EnumActivityNotifier │…│
│  │  (int state)        │  │  (freezed state enum) │  │
│  └─────────────────────┘  └──────────────────────┘  │
├──────────────────────────────────────────────────────┤
│               Data Layer (shared)                     │
│  ┌──────────────────┐  ┌─────────────────────────┐  │
│  │  Dio Provider    │──│→ Bored API (HTTP)        │  │
│  └──────────────────┘  └─────────────────────────┘  │
└──────────────────────────────────────────────────────┘
```

### Data Flow (for a typical activity-fetch page):

```
User taps "New Activity"
       │
       ▼
ref.read(provider.notifier).fetchActivity(type)
       │
       ▼
State → Loading (immutable copy via freezed / sealed subclass)
       │
       ▼
Dio GET  →  Parse JSON  →  Activity.fromJson()
       │
       ▼
State → Success(activities)   or   Failure(error)
       │
       ▼
Widget rebuilds via ref.watch() — switch/match on state variant
```

### Key design decisions:

| Decision | Rationale |
|---|---|
| **No `AsyncNotifier`** | The goal is to demonstrate hand-rolled async state, not delegate it to Riverpod's built-in `AsyncValue`. This gives full control over state shape and transition logic. |
| **Trigger location varies** | `initState` vs `build()` — lets teams decide which lifecycle hook fits their navigation and prefetching needs. |
| **Intentional error flips** | `_errorCounter % 2 != 1` causes every other fetch to fail — zero-config way to test loading/error/success cycles. |
| **No global services** | Every provider is scoped to its page via `@riverpod` code gen — strong encapsulation and trivial testing. |

---

## ✨ Key Features

### State Modelling Patterns

- **Simple Counter** — Auto-dispose family notifier; demonstrates parameterised providers and `ref.onDispose` lifecycle hooks.
- **Enum + Freezed** — Immutable state class with an explicit `ActivityStatus` enum (`initial`, `loading`, `success`, `failure`); fetch triggered in `initState`.
- **Enum + Freezed (Async)** — Same state shape but fetch triggered directly inside `build()`, no `initial` status; page uses `ConsumerWidget` instead of `ConsumerStatefulWidget`.
- **Sealed Class** — Plain Dart `sealed class` with `final` subclasses (`StateInitial`, `StateLoading`, `StateSuccess`, `StateFailure`); no code-gen annotations; fetch in `initState`.
- **Sealed Class (Async)** — Same sealed-class approach with fetch in `build()`; demonstrates `prevWidget` caching to preserve last successful UI on transient failure.

### Engineering Highlights

- ✅ **Exhaustive pattern matching** — Every UI branch is covered by `switch` expressions (no fallthrough, no forgotten states).
- ✅ **Error-first resilience** — Listeners on `ref.listen` show `AlertDialog` on failure without blocking the widget tree.
- ✅ **Lifecycle transparency** — Every provider prints a dispose message so you can verify cleanup in the debug console.
- ✅ **Generated code separation** — `.g.dart` and `.freezed.dart` are excluded from analysis, keeping `dart analyze` focused on hand-written sources.
- ✅ **`avoid_print: false`** — Print statements are intentional teaching tools; not a lint violation.

---

## 🚀 Getting Started & Local Setup

### Prerequisites

- Flutter SDK **^3.9.0** ([install guide](https://docs.flutter.dev/get-started/install))
- Dart SDK **^3.9.0** (bundled with Flutter)
- A platform-specific toolchain:
  - **Android:** Android Studio + Android SDK 21+
  - **iOS / macOS:** Xcode 15+ (macOS only)
  - **Web:** Chrome or Edge
  - **Linux / Windows:** Platform-specific desktop toolchain

<details>
<summary>📦 Verify your environment</summary>

```bash
flutter doctor
dart --version
```
</details>

### Clone & Run

```bash
# 1. Clone the repository
git clone https://github.com/your-org/notifier_provider.git
cd notifier_provider

# 2. Install dependencies
flutter pub get

# 3. Generate Riverpod + Freezed code
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app (choose your device)
flutter run                               # auto-selects device
flutter run -d chrome                     # web
flutter run -d android                    # Android emulator/device
flutter run -d macos                      # macOS desktop
```

> **Hot take:** The app works out of the box. No API keys, no `.env` file, no backend setup. The Bored API is public and requires zero authentication.

### Development Workflow

```bash
# Watch mode — regenerates *.g.dart and *.freezed.dart on every save
dart run build_runner watch --delete-conflicting-outputs

# Run a single test
flutter test test/widget_test.dart

# Run all tests
flutter test

# Lint
dart analyze

# Format
dart format .
```

---

## 📱 Screenshots & UI Showcase

| Light Mode | Dark Mode |
|---|---|
| <img src="https://via.placeholder.com/300x600/f5f5f5/333333?text=Light+Mode" width="200"/> | <img src="https://via.placeholder.com/300x600/1a1a2e/e94560?text=Dark+Mode" width="200"/> |

| Pattern: Enum + Freezed | Pattern: Sealed Class |
|---|---|
| <img src="https://via.placeholder.com/300x600/16213e/0f3460?text=Enum+Freezed" width="200"/> | <img src="https://via.placeholder.com/300x600/0f3460/53d769?text=Sealed+Class" width="200"/> |

> Replace placeholder URLs with your actual screenshots. Recommended tool: [Firebase Test Lab](https://firebase.google.com/docs/test-lab) or `adb screencap` / `xcrun simctl screenshot`.

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

## 🤝 Contact & Community

| Role | Contact |
|---|---|
| **Project Lead** | [Your Name](https://linkedin.com/in/your-profile) — `your.email@example.com` |
| **GitHub Organisation** | [github.com/your-org](https://github.com/your-org) |
| **Issue Tracker** | [GitHub Issues](https://github.com/your-org/notifier_provider/issues) |

<p align="center">
  <sub>Built with ❤️ using Flutter & Riverpod &nbsp;|&nbsp; ⭐ Star this repo if you found it useful!</sub>
</p>
