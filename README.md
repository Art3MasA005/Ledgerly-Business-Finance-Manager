# Ledgerly

**দোকানের হিসাব, বাকি, বিক্রি, স্টক, খরচ ও রিপোর্ট — সব এক অ্যাপে।**

Ledgerly is an offline-first Flutter ledger app for small businesses in Bangladesh — shop owners, mobile sellers, and wholesalers who need a simple way to track daily sales, customer/supplier baki (dues), expenses, stock, and cashbox, with cloud backup so data is never lost. Full requirements live in [`prd.md`](prd.md).

## Key Features (MVP)

- **Customer & supplier ledger** — record "দিলাম" (gave) / "পেলাম" (received) transactions, partial payments, and running pabo/debo balances.
- **Sales entry** — full or due sales with payment method (Cash, bKash, Nagad, Rocket, Bank, Other).
- **Expenses & cashbox** — categorized expense tracking and daily cash summaries.
- **Home dashboard** — total pabo/debo, today's sales/expenses, and a daily sales bar chart.
- **Import** — migrate existing TaliKhata-style PDF exports with a preview, duplicate detection, and opening-balance creation.
- **Export** — PDF/CSV reports (ledger, sales, due) shareable via WhatsApp/Messenger/email.
- **Offline-first sync** — every write lands locally first and syncs to Supabase automatically when online; full restore on re-login from any device.
- **Subscription** — BDT 30/month via bKash/Nagad/Rocket; expired accounts stay read-only (view/export/backup), never lose data.
- **Bangla + English** — Bangla-first wording (পাবে, দেবে, বাকি, খরচ) with English support throughout.

## Tech Stack

| Layer | Choice |
|---|---|
| App framework | Flutter (Dart >=3.5.0) |
| State management | Riverpod (`flutter_riverpod`, code-gen via `riverpod_generator`) |
| Local database | Drift (SQLite) — offline storage + sync queue |
| Backend | Supabase (Auth, Postgres + RLS, Storage, Edge Functions) |
| Navigation | `go_router` |
| Charts | `fl_chart` |
| PDF export/import | `pdf`, `printing`, `syncfusion_flutter_pdf` |
| Auth | Phone OTP, email OTP, Google Sign-In via Supabase Auth |

See [`pubspec.yaml`](pubspec.yaml) for the full dependency list.

## Project Structure

```
lib/
├── core/
│   ├── constants/     # App config, table names, storage buckets, enums
│   ├── router/        # go_router route definitions
│   ├── theme/         # App theme, colors (pabo/debo, brand palette)
│   ├── utils/         # Formatters (currency, date, Bangla numerals)
│   └── widgets/       # Shared shell/navigation widgets
├── features/
│   ├── auth/          # Splash, onboarding, login, OTP
│   ├── contacts/      # Customer/supplier list, detail, add
│   ├── ledger/        # Add ledger transaction
│   ├── sales/         # Sales list, add sale
│   ├── expenses/      # Add expense
│   ├── home/          # Dashboard (providers + screen)
│   ├── import/        # TaliKhata PDF import
│   ├── export/        # Report export
│   ├── reports/       # Reports screen
│   ├── subscription/  # Subscription + payment screens
│   └── settings/      # App settings
├── local_db/           # Drift tables/DAOs (offline-first storage) — scaffolded, in progress
├── models/             # Shared data models
├── services/            # Supabase service wrapper
└── main.dart
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart >=3.5.0)
- Android Studio / VS Code with the Flutter & Dart plugins
- An Android emulator or device (Android is the first-launch target; iOS/Web/Desktop scaffolding is present via Flutter but untargeted for MVP)
- A [Supabase](https://supabase.com) project (URL + anon key)

### Setup

1. **Clone and install dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate code** (Drift tables, Riverpod providers)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Configure Supabase**
   Project credentials are set in [`lib/core/constants/app_config.dart`](lib/core/constants/app_config.dart) (`supabaseUrl`, `supabaseAnonKey`). Update these to point at your own Supabase project before running against real data. For production builds, prefer passing secrets via `--dart-define` instead of committing them to source.

4. **Run the app**
   ```bash
   flutter run
   ```

### Useful commands

```bash
flutter analyze              # Static analysis (flutter_lints)
flutter test                 # Run tests
dart run build_runner watch  # Regenerate Drift/Riverpod code on save
```

## Troubleshooting

**Gradle build fails with `Unexpected lock protocol found in lock file`** (Windows): this means the local Gradle cache got corrupted (usually from an interrupted build or multiple Gradle daemon versions writing to the cache concurrently). Fix:
```powershell
& android\gradlew.bat --stop
Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\caches"
Remove-Item -Recurse -Force "android\.gradle"
```
Then rebuild — Gradle will re-download what it needs.

## Project Status

This project is under active development against the [PRD](prd.md). Screen scaffolding exists for all MVP modules (auth, ledger, sales, expenses, import/export, subscription, reports); the Drift offline database layer (`lib/local_db/`) and full Supabase sync pipeline are in progress. See [`prd.md`](prd.md) §5 and §16 for locked MVP scope and the release roadmap.

## License

Private project — not published (`publish_to: none`).
