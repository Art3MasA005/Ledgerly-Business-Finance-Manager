import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';
import '../../../models/models.dart';

// ─── Auth State Stream ─────────────────────────────────────────────────────────

final authStateProvider = StreamProvider<User?>((ref) {
  return SupabaseService.authStateChanges.map((event) => event.session?.user);
});

// ─── Current User Profile ─────────────────────────────────────────────────────

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;

  final data = await SupabaseService.getProfile(user.id);
  if (data == null) return null;
  return UserProfile.fromJson(data);
});

// ─── Current Business ─────────────────────────────────────────────────────────

final currentBusinessProvider =
    StateNotifierProvider<CurrentBusinessNotifier, Business?>(
  (ref) => CurrentBusinessNotifier(),
);

class CurrentBusinessNotifier extends StateNotifier<Business?> {
  CurrentBusinessNotifier() : super(null);

  Future<void> load() async {
    try {
      final list = await SupabaseService.getBusinesses();
      if (list.isNotEmpty) {
        state = Business.fromJson(list.first);
      }
    } catch (_) {}
  }

  void select(Business business) => state = business;

  Future<Business> create(Map<String, dynamic> data) async {
    final res = await SupabaseService.createBusiness(data);
    final business = Business.fromJson(res);
    state = business;
    return business;
  }
}

// ─── Auth Notifier ────────────────────────────────────────────────────────────

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  AuthNotifier(this._ref) : super(const AsyncData(null));

  Future<void> sendPhoneOtp(String phone) async {
    state = const AsyncLoading();
    try {
      await SupabaseService.sendPhoneOtp(phone);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<bool> verifyPhoneOtp({
    required String phone,
    required String token,
  }) async {
    state = const AsyncLoading();
    try {
      final res = await SupabaseService.verifyPhoneOtp(
        phone: phone,
        token: token,
      );
      if (res.user != null) {
        // Ensure profile exists
        await _ensureProfile(res.user!);
        state = const AsyncData(null);
        return true;
      }
      state = const AsyncData(null);
      return false;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<void> sendEmailOtp(String email) async {
    state = const AsyncLoading();
    try {
      await SupabaseService.sendEmailOtp(email);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<bool> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    state = const AsyncLoading();
    try {
      final res = await SupabaseService.verifyEmailOtp(
        email: email,
        token: token,
      );
      if (res.user != null) {
        await _ensureProfile(res.user!);
        state = const AsyncData(null);
        return true;
      }
      state = const AsyncData(null);
      return false;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await SupabaseService.signInWithGoogle();
      final user = SupabaseService.currentUser;
      if (user != null) await _ensureProfile(user);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    await SupabaseService.signOut();
    _ref.read(currentBusinessProvider.notifier).select(
          Business(
            id: '',
            ownerId: '',
            name: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<void> _ensureProfile(User user) async {
    final existing = await SupabaseService.getProfile(user.id);
    if (existing == null) {
      await SupabaseService.upsertProfile({
        'id': user.id,
        'email': user.email,
        'phone': user.phone,
        'name': user.userMetadata?['full_name'] ??
            user.userMetadata?['name'] ??
            user.email?.split('@').first,
      });
    }
    // Load business after profile
    await _ref.read(currentBusinessProvider.notifier).load();
  }
}
