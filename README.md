<div align="center">

# 📒 Ledgerly

### **Track sales, dues, expenses & reports — all in one app.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%E2%89%A53.5.0-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=flat-square&logo=supabase)](https://supabase.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-State%20Management-blue?style=flat-square)](https://riverpod.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android-green?style=flat-square&logo=android)](https://developer.android.com)

</div>

---

## Overview

**Ledgerly** is an **offline-first Flutter ledger app** built for small business owners in Bangladesh — shop keepers, mobile sellers, and wholesalers who need a fast, reliable way to manage their day-to-day finances without depending on an internet connection.

> Built as a **portfolio project** demonstrating production-grade Flutter architecture: Supabase cloud sync, offline-first Drift/SQLite, Riverpod state management, and a bilingual UI.

---

## Key Features

| Feature | Description |
|---|---|
| 📖 **Ledger** | Record credit/debit transactions with partial payments and running receivable/payable balances |
| 🛒 **Sales Entry** | Full or due sales with payment method — Cash, bKash, Nagad, Rocket, Bank |
| 💸 **Expenses & Cashbox** | Categorized expense tracking and daily cash summaries |
| 📊 **Dashboard** | Total dues/receivables, today's sales/expenses, and a daily bar chart |
| 📥 **PDF Import** | Migrate existing TaliKhata PDF exports with duplicate detection and opening-balance creation |
| 📤 **PDF/CSV Export** | Shareable ledger, sales & due reports via WhatsApp / Messenger / email |
| ☁️ **Offline-first Sync** | Every write lands locally first; auto-syncs to Supabase when online — full restore on any device |
| 💳 **Subscription** | BDT 30/month; expired accounts stay read-only (view/export/backup) — data is never lost |
| 🌐 **Bilingual** | English and local language support |

---

## Tech Stack

| Layer | Choice |
|---|---|
| **App Framework** | Flutter (Dart >= 3.5.0) |
| **State Management** | Riverpod (`flutter_riverpod` + code-gen via `riverpod_generator`) |
| **Local Database** | Drift (SQLite) — offline-first storage + sync queue |
| **Backend** | Supabase (Auth · Postgres + RLS · Storage · Edge Functions) |
| **Navigation** | `go_router` |
| **Charts** | `fl_chart` |
| **PDF Export/Import** | `pdf`, `printing`, `syncfusion_flutter_pdf` |
| **Auth** | Phone OTP · Email OTP · Google Sign-In via Supabase Auth |
| **Fonts** | Google Fonts (Hind Siliguri, Inter) |

Full dependency list → [`pubspec.yaml`](pubspec.yaml)

---

## Project Structure

```
lib/
├── core/
│   ├── constants/     # App config (dart-define env vars), table names, enums
│   ├── router/        # go_router route definitions
│   ├── theme/         # App theme, colors (pabo/debo, brand palette)
│   ├── utils/         # Formatters (currency, date, Bangla numerals)
│   └── widgets/       # Shared shell/navigation widgets
├── features/
│   ├── auth/          # Splash, onboarding, login, OTP verification
│   ├── contacts/      # Customer/supplier list, detail, add
│   ├── ledger/        # Add/view ledger transactions
│   ├── sales/         # Sales list, add sale
│   ├── expenses/      # Add expense, cashbox
│   ├── home/          # Dashboard (providers + screen)
│   ├── import/        # TaliKhata PDF import pipeline
│   ├── export/        # PDF/CSV report export
│   ├── reports/       # Reports screen
│   ├── subscription/  # Subscription & payment screens
│   └── settings/      # App settings
├── local_db/          # Drift tables & DAOs (offline-first storage)
├── models/            # Shared data models
├── services/          # Supabase service wrapper
└── main.dart
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart >= 3.5.0)
- Android Studio or VS Code with Flutter & Dart plugins
- An Android emulator or physical device (primary target platform)
- A [Supabase](https://supabase.com) project — free tier works

### Setup

**1. Clone the repository**
```bash
git clone https://github.com/your-username/ledgerly.git
cd ledgerly
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Generate code** *(Drift tables + Riverpod providers)*
```bash
dart run build_runner build --delete-conflicting-outputs
```

**4. Configure Supabase credentials**

Credentials are injected at build-time via `--dart-define` — they are **never** stored in source code.

Copy the example env file and fill in your own values:
```bash
cp .env.example .env
# Edit .env — add your Supabase URL and anon key
```

**5. Run the app**
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

> **VS Code users:** Add the `--dart-define` args to your `launch.json` (already in `.gitignore`).
> **Android Studio users:** Add them under *Run > Edit Configurations > Additional run args*.

---

### Useful Commands

```bash
# Static analysis
flutter analyze

# Run tests
flutter test

# Watch mode — regenerate Drift/Riverpod code on save
dart run build_runner watch --delete-conflicting-outputs

# Build release APK
flutter build apk \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --release
```

---

## Troubleshooting

**Gradle fails with `Unexpected lock protocol found in lock file`** (Windows)

The local Gradle cache got corrupted — usually from an interrupted build. Fix:
```powershell
& android\gradlew.bat --stop
Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\caches"
Remove-Item -Recurse -Force "android\.gradle"
```
Then rebuild — Gradle will re-download what it needs.

---

**`SUPABASE_URL` is empty at runtime**

`String.fromEnvironment` resolves at **compile time**. Shell environment variables are not picked up automatically — you must pass them explicitly via `--dart-define` on every `flutter run` / `flutter build` call.

---

## Project Status

> **Active development** — MVP in progress.

Screen scaffolding exists for all MVP modules (auth, ledger, sales, expenses, import/export, subscription, reports). The Drift offline database layer (`lib/local_db/`) and full Supabase sync pipeline are actively being built. See [`prd.md`](prd.md) for the locked MVP scope and release roadmap.

---

## Contributing

This is a portfolio project. Issues and PRs are welcome — feel free to open a discussion if you'd like to contribute or suggest improvements.

---

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">
Made with love for Bangladeshi small business owners &nbsp;|&nbsp; Built with Flutter & Supabase
</div>
