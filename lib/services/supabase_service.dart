import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_config.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      // ignore: deprecated_member_use
      anonKey: AppConfig.supabaseAnonKey,
      debug: false,
    );
  }

  static User? get currentUser => client.auth.currentUser;
  static Session? get currentSession => client.auth.currentSession;
  static bool get isLoggedIn => currentUser != null;

  // ─── Auth ─────────────────────────────────────────────────────────────────

  static Future<AuthResponse> signInWithPhone({
    required String phone,
    required String password,
  }) async {
    return client.auth.signInWithPassword(phone: phone, password: password);
  }

  static Future<void> sendPhoneOtp(String phone) async {
    await client.auth.signInWithOtp(phone: phone);
  }

  static Future<AuthResponse> verifyPhoneOtp({
    required String phone,
    required String token,
  }) async {
    return client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  static Future<void> sendEmailOtp(String email) async {
    await client.auth.signInWithOtp(
      email: email,
      // Removed emailRedirectTo as we are using a 6-digit code now
    );
  }

  static Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    return client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.email,
    );
  }

  static Future<void> signInWithGoogle() async {
    await client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.ledgerly.app://login-callback',
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;

  // ─── Profiles ─────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> getProfile(String userId) async {
    final res = await client
        .from(TableNames.profiles)
        .select()
        .eq('id', userId)
        .maybeSingle();
    return res;
  }

  static Future<void> upsertProfile(Map<String, dynamic> data) async {
    await client.from(TableNames.profiles).upsert(data);
  }

  // ─── Businesses ───────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getBusinesses() async {
    return await client
        .from(TableNames.businesses)
        .select()
        .isFilter('deleted_at', null)
        .order('created_at', ascending: true);
  }

  static Future<Map<String, dynamic>> createBusiness(
      Map<String, dynamic> data) async {
    final res = await client
        .from(TableNames.businesses)
        .insert(data)
        .select()
        .single();
    return res;
  }

  static Future<void> updateBusiness(
      String id, Map<String, dynamic> data) async {
    await client.from(TableNames.businesses).update(data).eq('id', id);
  }

  // ─── Contacts ─────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getContacts(
      String businessId) async {
    return await client
        .from('contact_balances')
        .select()
        .eq('business_id', businessId)
        .isFilter('archived_at', null)
        .order('last_transaction_at', ascending: false, nullsFirst: false);
  }

  static Future<Map<String, dynamic>> createContact(
      Map<String, dynamic> data) async {
    final res = await client
        .from(TableNames.contacts)
        .insert(data)
        .select()
        .single();
    return res;
  }

  static Future<void> updateContact(String id, Map<String, dynamic> data) async {
    await client.from(TableNames.contacts).update(data).eq('id', id);
  }

  // ─── Ledger Transactions ──────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getTransactions({
    required String businessId,
    String? contactId,
    DateTime? from,
    DateTime? to,
  }) async {
    var query = client
        .from(TableNames.ledgerTransactions)
        .select()
        .eq('business_id', businessId)
        .isFilter('deleted_at', null);

    if (contactId != null) {
      query = query.eq('contact_id', contactId);
    }
    if (from != null) {
      query = query.gte('date', from.toIso8601String().split('T')[0]);
    }
    if (to != null) {
      query = query.lte('date', to.toIso8601String().split('T')[0]);
    }

    return await query.order('date', ascending: false).order('created_at', ascending: false);
  }

  static Future<Map<String, dynamic>> createTransaction(
      Map<String, dynamic> data) async {
    final res = await client
        .from(TableNames.ledgerTransactions)
        .insert(data)
        .select()
        .single();
    return res;
  }

  // ─── Sales ────────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getSales({
    required String businessId,
    DateTime? from,
    DateTime? to,
  }) async {
    var query = client
        .from(TableNames.sales)
        .select('*, contacts(name, phone)')
        .eq('business_id', businessId)
        .isFilter('deleted_at', null);

    if (from != null) {
      query = query.gte('date', from.toIso8601String().split('T')[0]);
    }
    if (to != null) {
      query = query.lte('date', to.toIso8601String().split('T')[0]);
    }

    return await query.order('date', ascending: false);
  }

  static Future<Map<String, dynamic>> createSale(
      Map<String, dynamic> data) async {
    final res = await client
        .from(TableNames.sales)
        .insert(data)
        .select()
        .single();
    return res;
  }

  // ─── Daily Sales Chart ────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getDailySales({
    required String businessId,
    required int days,
  }) async {
    final from = DateTime.now().subtract(Duration(days: days - 1));
    return await client
        .from('daily_sales_summary')
        .select()
        .eq('business_id', businessId)
        .gte('date', from.toIso8601String().split('T')[0])
        .order('date', ascending: true);
  }

  // ─── Expenses ─────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> createExpense(
      Map<String, dynamic> data) async {
    final res = await client
        .from(TableNames.expenses)
        .insert(data)
        .select()
        .single();
    return res;
  }

  static Future<List<Map<String, dynamic>>> getExpenses({
    required String businessId,
    DateTime? from,
    DateTime? to,
  }) async {
    var query = client
        .from(TableNames.expenses)
        .select()
        .eq('business_id', businessId)
        .isFilter('deleted_at', null);

    if (from != null) {
      query = query.gte('date', from.toIso8601String().split('T')[0]);
    }
    if (to != null) {
      query = query.lte('date', to.toIso8601String().split('T')[0]);
    }

    return await query.order('date', ascending: false);
  }

  // ─── Business Summary ─────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> getBusinessSummary(
      String businessId) async {
    final res = await client.rpc(
      'get_business_summary',
      params: {'p_business_id': businessId},
    );
    return res as Map<String, dynamic>;
  }

  // ─── Subscription ─────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> getSubscription(
      String businessId) async {
    return await client
        .from(TableNames.subscriptions)
        .select()
        .eq('business_id', businessId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }

  static Future<Map<String, dynamic>> createSubscription(
      Map<String, dynamic> data) async {
    final res = await client
        .from(TableNames.subscriptions)
        .insert(data)
        .select()
        .single();
    return res;
  }

  static Future<Map<String, dynamic>> submitPayment(
      Map<String, dynamic> data) async {
    final res = await client
        .from(TableNames.subscriptionPayments)
        .insert(data)
        .select()
        .single();
    return res;
  }

  // ─── Import Jobs ──────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> createImportJob(
      Map<String, dynamic> data) async {
    final res = await client
        .from(TableNames.importJobs)
        .insert(data)
        .select()
        .single();
    return res;
  }

  static Future<List<Map<String, dynamic>>> getImportJobs(
      String businessId) async {
    return await client
        .from(TableNames.importJobs)
        .select()
        .eq('business_id', businessId)
        .order('created_at', ascending: false);
  }
}
