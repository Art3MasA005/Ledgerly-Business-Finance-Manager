// Supabase configuration for Ledgerly
//
// Credentials are injected at build-time via --dart-define so they are
// never committed to source control. See README.md § Setup for details.
//
// Usage:
//   flutter run \
//     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
//     --dart-define=SUPABASE_ANON_KEY=your-anon-key

class AppConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '', // Set via --dart-define at build time
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '', // Set via --dart-define at build time
  );

  // App Info
  static const String appName = 'Ledgerly';
  static const String appNameBn = 'লেজারলি';
  static const String appTaglineBn = 'দোকানের হিসাব, বাকি, বিক্রি ও রিপোর্ট সহজে রাখার অ্যাপ।';

  // Subscription
  static const int subscriptionPriceBdt = 30;
  static const int trialDays = 7;

  // Sync
  static const Duration syncDebounce = Duration(seconds: 3);
  static const int maxSyncRetries = 5;

  // PDF Import
  static const double importConfidenceThreshold = 0.7;
}

class TableNames {
  static const String profiles = 'profiles';
  static const String businesses = 'businesses';
  static const String businessMembers = 'business_members';
  static const String contacts = 'contacts';
  static const String ledgerTransactions = 'ledger_transactions';
  static const String sales = 'sales';
  static const String saleItems = 'sale_items';
  static const String expenses = 'expenses';
  static const String products = 'products';
  static const String inventoryMovements = 'inventory_movements';
  static const String importJobs = 'import_jobs';
  static const String importRows = 'import_rows';
  static const String subscriptions = 'subscriptions';
  static const String subscriptionPayments = 'subscription_payments';
  static const String syncOperations = 'sync_operations';
  static const String auditLogs = 'audit_logs';
}

class StorageBuckets {
  static const String reports = 'reports';
  static const String receipts = 'receipts';
  static const String importFiles = 'import-files';
  static const String logos = 'logos';
}

class ExpenseCategories {
  static const List<Map<String, String>> all = [
    {'key': 'rent', 'bn': 'ভাড়া', 'en': 'Rent'},
    {'key': 'salary', 'bn': 'বেতন', 'en': 'Salary'},
    {'key': 'electricity', 'bn': 'বিদ্যুৎ', 'en': 'Electricity'},
    {'key': 'transport', 'bn': 'পরিবহন', 'en': 'Transport'},
    {'key': 'purchase', 'bn': 'মাল কেনা', 'en': 'Purchase'},
    {'key': 'food', 'bn': 'খাবার', 'en': 'Food'},
    {'key': 'marketing', 'bn': 'মার্কেটিং', 'en': 'Marketing'},
    {'key': 'repair', 'bn': 'মেরামত', 'en': 'Repair'},
    {'key': 'other', 'bn': 'অন্যান্য', 'en': 'Other'},
  ];
}
