import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/supabase_service.dart';
import '../../../models/models.dart';
import '../../auth/providers/auth_provider.dart';

// ─── Business Summary ─────────────────────────────────────────────────────────

final businessSummaryProvider =
    FutureProvider.autoDispose<BusinessSummary>((ref) async {
  final business = ref.watch(currentBusinessProvider);
  if (business == null || business.id.isEmpty) {
    return const BusinessSummary();
  }
  final data = await SupabaseService.getBusinessSummary(business.id);
  return BusinessSummary.fromJson(data);
});

// ─── Daily Sales Chart Data ───────────────────────────────────────────────────

final chartDaysProvider = StateProvider<int>((ref) => 7);

final dailySalesProvider =
    FutureProvider.autoDispose<List<DailySalesData>>((ref) async {
  final business = ref.watch(currentBusinessProvider);
  final days = ref.watch(chartDaysProvider);
  if (business == null || business.id.isEmpty) return [];

  final rows = await SupabaseService.getDailySales(
    businessId: business.id,
    days: days,
  );

  return rows.map((r) => DailySalesData.fromJson(r)).toList();
});

// ─── Contacts List ─────────────────────────────────────────────────────────────

final contactsProvider =
    FutureProvider.autoDispose<List<Contact>>((ref) async {
  final business = ref.watch(currentBusinessProvider);
  if (business == null || business.id.isEmpty) return [];

  final rows = await SupabaseService.getContacts(business.id);
  return rows.map((r) => Contact.fromJson(r)).toList();
});

// ─── Subscription ─────────────────────────────────────────────────────────────

final subscriptionProvider =
    FutureProvider.autoDispose<Subscription?>((ref) async {
  final business = ref.watch(currentBusinessProvider);
  if (business == null || business.id.isEmpty) return null;

  final data = await SupabaseService.getSubscription(business.id);
  if (data == null) return null;
  return Subscription.fromJson(data);
});

// ─── Models ────────────────────────────────────────────────────────────────────

class DailySalesData {
  final DateTime date;
  final int saleCount;
  final double totalSales;
  final double totalPaid;
  final double totalDue;

  const DailySalesData({
    required this.date,
    this.saleCount = 0,
    this.totalSales = 0,
    this.totalPaid = 0,
    this.totalDue = 0,
  });

  factory DailySalesData.fromJson(Map<String, dynamic> json) => DailySalesData(
        date: DateTime.parse(json['date']),
        saleCount: json['sale_count'] ?? 0,
        totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0,
        totalPaid: (json['total_paid'] as num?)?.toDouble() ?? 0,
        totalDue: (json['total_due'] as num?)?.toDouble() ?? 0,
      );
}
