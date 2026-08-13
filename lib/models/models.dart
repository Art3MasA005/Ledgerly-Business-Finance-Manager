import 'package:equatable/equatable.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum ContactType { customer, supplier, both }

enum LedgerDirection {
  gave,
  received,
  openingReceivable,
  openingPayable,
  adjustment
}

enum PaymentMethod {
  cash,
  bkash,
  nagad,
  rocket,
  bank,
  card,
  cheque,
  other
}

enum SubscriptionStatus {
  trial,
  active,
  expiring,
  expired,
  pending,
  suspended
}

enum SyncStatus { pending, syncing, synced, failed, conflict }

enum ImportStatus {
  draft,
  parsed,
  needsReview,
  imported,
  partial,
  failed,
  rolledBack
}

// ─── Extension Helpers ────────────────────────────────────────────────────────

extension ContactTypeExt on ContactType {
  String get nameBn {
    switch (this) {
      case ContactType.customer: return 'কাস্টমার';
      case ContactType.supplier: return 'সাপ্লায়ার';
      case ContactType.both: return 'কাস্টমার ও সাপ্লায়ার';
    }
  }

  String get dbValue {
    switch (this) {
      case ContactType.customer: return 'customer';
      case ContactType.supplier: return 'supplier';
      case ContactType.both: return 'both';
    }
  }

  static ContactType fromDb(String val) {
    switch (val) {
      case 'supplier': return ContactType.supplier;
      case 'both': return ContactType.both;
      default: return ContactType.customer;
    }
  }
}

extension LedgerDirectionExt on LedgerDirection {
  String get nameBn {
    switch (this) {
      case LedgerDirection.gave: return 'দিলাম';
      case LedgerDirection.received: return 'পেলাম';
      case LedgerDirection.openingReceivable: return 'পাবো (শুরু)';
      case LedgerDirection.openingPayable: return 'দেবো (শুরু)';
      case LedgerDirection.adjustment: return 'সমন্বয়';
    }
  }

  String get dbValue {
    switch (this) {
      case LedgerDirection.gave: return 'gave';
      case LedgerDirection.received: return 'received';
      case LedgerDirection.openingReceivable: return 'opening_receivable';
      case LedgerDirection.openingPayable: return 'opening_payable';
      case LedgerDirection.adjustment: return 'adjustment';
    }
  }

  static LedgerDirection fromDb(String val) {
    switch (val) {
      case 'received': return LedgerDirection.received;
      case 'opening_receivable': return LedgerDirection.openingReceivable;
      case 'opening_payable': return LedgerDirection.openingPayable;
      case 'adjustment': return LedgerDirection.adjustment;
      default: return LedgerDirection.gave;
    }
  }
}

extension PaymentMethodExt on PaymentMethod {
  String get nameBn {
    switch (this) {
      case PaymentMethod.cash: return 'নগদ';
      case PaymentMethod.bkash: return 'বিকাশ';
      case PaymentMethod.nagad: return 'নগদ (মোবাইল)';
      case PaymentMethod.rocket: return 'রকেট';
      case PaymentMethod.bank: return 'ব্যাংক';
      case PaymentMethod.card: return 'কার্ড';
      case PaymentMethod.cheque: return 'চেক';
      case PaymentMethod.other: return 'অন্যান্য';
    }
  }

  String get dbValue => name;

  static PaymentMethod fromDb(String? val) {
    switch (val) {
      case 'bkash': return PaymentMethod.bkash;
      case 'nagad': return PaymentMethod.nagad;
      case 'rocket': return PaymentMethod.rocket;
      case 'bank': return PaymentMethod.bank;
      case 'card': return PaymentMethod.card;
      case 'cheque': return PaymentMethod.cheque;
      case 'other': return PaymentMethod.other;
      default: return PaymentMethod.cash;
    }
  }
}

extension SubscriptionStatusExt on SubscriptionStatus {
  bool get canWrite =>
      this == SubscriptionStatus.trial ||
      this == SubscriptionStatus.active ||
      this == SubscriptionStatus.expiring;

  String get badgeLabelBn {
    switch (this) {
      case SubscriptionStatus.trial: return 'ট্রায়াল';
      case SubscriptionStatus.active: return 'সক্রিয়';
      case SubscriptionStatus.expiring: return 'শেষ হচ্ছে';
      case SubscriptionStatus.expired: return 'মেয়াদ শেষ';
      case SubscriptionStatus.pending: return 'যাচাই হচ্ছে';
      case SubscriptionStatus.suspended: return 'স্থগিত';
    }
  }
}

// ─── Domain Models ────────────────────────────────────────────────────────────

class UserProfile extends Equatable {
  final String id;
  final String? name;
  final String? phone;
  final String? email;
  final String language;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    this.name,
    this.phone,
    this.email,
    this.language = 'bn',
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        language: json['language'] ?? 'bn',
        avatarUrl: json['avatar_url'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'language': language,
        'avatar_url': avatarUrl,
      };

  @override
  List<Object?> get props => [id, name, phone, email, language];
}

class Business extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String? phone;
  final String? address;
  final String? logoUrl;
  final String businessType;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Business({
    required this.id,
    required this.ownerId,
    required this.name,
    this.phone,
    this.address,
    this.logoUrl,
    this.businessType = 'other',
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json['id'],
        ownerId: json['owner_id'],
        name: json['name'],
        phone: json['phone'],
        address: json['address'],
        logoUrl: json['logo_url'],
        businessType: json['business_type'] ?? 'other',
        isActive: json['is_active'] ?? true,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'owner_id': ownerId,
        'name': name,
        'phone': phone,
        'address': address,
        'logo_url': logoUrl,
        'business_type': businessType,
        'is_active': isActive,
      };

  @override
  List<Object?> get props => [id, name, ownerId];
}

class Contact extends Equatable {
  final String id;
  final String businessId;
  final String name;
  final String? phone;
  final ContactType type;
  final String? address;
  final String? notes;
  final double openingBalance;
  final LedgerDirection openingBalanceDirection;
  final String? avatarColor;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Computed from view
  final double? balance;
  final DateTime? lastTransactionDate;

  const Contact({
    required this.id,
    required this.businessId,
    required this.name,
    this.phone,
    this.type = ContactType.customer,
    this.address,
    this.notes,
    this.openingBalance = 0,
    this.openingBalanceDirection = LedgerDirection.openingReceivable,
    this.avatarColor,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
    this.balance,
    this.lastTransactionDate,
  });

  bool get isArchived => archivedAt != null;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json['id'],
        businessId: json['business_id'],
        name: json['name'],
        phone: json['phone'],
        type: ContactTypeExt.fromDb(json['type'] ?? 'customer'),
        address: json['address'],
        notes: json['notes'],
        openingBalance: (json['opening_balance'] as num?)?.toDouble() ?? 0,
        openingBalanceDirection: LedgerDirectionExt.fromDb(
            json['opening_balance_direction'] ?? 'opening_receivable'),
        avatarColor: json['avatar_color'],
        archivedAt: json['archived_at'] != null
            ? DateTime.parse(json['archived_at'])
            : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        balance: (json['balance'] as num?)?.toDouble(),
        lastTransactionDate: json['last_transaction_date'] != null
            ? DateTime.parse(json['last_transaction_date'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'name': name,
        'phone': phone,
        'type': type.dbValue,
        'address': address,
        'notes': notes,
        'opening_balance': openingBalance,
        'opening_balance_direction': openingBalanceDirection.dbValue,
        'avatar_color': avatarColor,
      };

  @override
  List<Object?> get props => [id, name, phone, businessId, type];
}

class LedgerTransaction extends Equatable {
  final String id;
  final String businessId;
  final String contactId;
  final LedgerDirection direction;
  final double amount;
  final DateTime date;
  final String? note;
  final PaymentMethod paymentMethod;
  final String source;
  final String? importJobId;
  final String operationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const LedgerTransaction({
    required this.id,
    required this.businessId,
    required this.contactId,
    required this.direction,
    required this.amount,
    required this.date,
    this.note,
    this.paymentMethod = PaymentMethod.cash,
    this.source = 'manual',
    this.importJobId,
    required this.operationId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  bool get isDeleted => deletedAt != null;

  factory LedgerTransaction.fromJson(Map<String, dynamic> json) =>
      LedgerTransaction(
        id: json['id'],
        businessId: json['business_id'],
        contactId: json['contact_id'],
        direction: LedgerDirectionExt.fromDb(json['direction']),
        amount: (json['amount'] as num).toDouble(),
        date: DateTime.parse(json['date']),
        note: json['note'],
        paymentMethod: PaymentMethodExt.fromDb(json['payment_method']),
        source: json['source'] ?? 'manual',
        importJobId: json['import_job_id'],
        operationId: json['operation_id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] != null
            ? DateTime.parse(json['deleted_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'contact_id': contactId,
        'direction': direction.dbValue,
        'amount': amount,
        'date': date.toIso8601String().split('T')[0],
        'note': note,
        'payment_method': paymentMethod.dbValue,
        'source': source,
        'import_job_id': importJobId,
        'operation_id': operationId,
      };

  @override
  List<Object?> get props => [id, operationId, amount, direction];
}

class Sale extends Equatable {
  final String id;
  final String businessId;
  final String? contactId;
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;
  final DateTime date;
  final String status;
  final PaymentMethod paymentMethod;
  final String? note;
  final String operationId;
  final DateTime createdAt;
  // Optionally joined
  final String? contactName;

  const Sale({
    required this.id,
    required this.businessId,
    this.contactId,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
    required this.date,
    this.status = 'completed',
    this.paymentMethod = PaymentMethod.cash,
    this.note,
    required this.operationId,
    required this.createdAt,
    this.contactName,
  });

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        id: json['id'],
        businessId: json['business_id'],
        contactId: json['contact_id'],
        totalAmount: (json['total_amount'] as num).toDouble(),
        paidAmount: (json['paid_amount'] as num).toDouble(),
        dueAmount: (json['due_amount'] as num).toDouble(),
        date: DateTime.parse(json['date']),
        status: json['status'] ?? 'completed',
        paymentMethod: PaymentMethodExt.fromDb(json['payment_method']),
        note: json['note'],
        operationId: json['operation_id'],
        createdAt: DateTime.parse(json['created_at']),
        contactName: json['contacts']?['name'],
      );

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'contact_id': contactId,
        'total_amount': totalAmount,
        'paid_amount': paidAmount,
        'date': date.toIso8601String().split('T')[0],
        'status': status,
        'payment_method': paymentMethod.dbValue,
        'note': note,
        'operation_id': operationId,
      };

  @override
  List<Object?> get props => [id, operationId, totalAmount, date];
}

class Expense extends Equatable {
  final String id;
  final String businessId;
  final String category;
  final double amount;
  final DateTime date;
  final String? note;
  final PaymentMethod paymentMethod;
  final String operationId;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.businessId,
    required this.category,
    required this.amount,
    required this.date,
    this.note,
    this.paymentMethod = PaymentMethod.cash,
    required this.operationId,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'],
        businessId: json['business_id'],
        category: json['category'] ?? 'other',
        amount: (json['amount'] as num).toDouble(),
        date: DateTime.parse(json['date']),
        note: json['note'],
        paymentMethod: PaymentMethodExt.fromDb(json['payment_method']),
        operationId: json['operation_id'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'category': category,
        'amount': amount,
        'date': date.toIso8601String().split('T')[0],
        'note': note,
        'payment_method': paymentMethod.dbValue,
        'operation_id': operationId,
      };

  @override
  List<Object?> get props => [id, operationId, amount, date];
}

class Subscription extends Equatable {
  final String id;
  final String businessId;
  final String userId;
  final String plan;
  final SubscriptionStatus status;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final DateTime? trialEndsAt;
  final DateTime createdAt;

  const Subscription({
    required this.id,
    required this.businessId,
    required this.userId,
    this.plan = 'monthly',
    required this.status,
    this.startsAt,
    this.expiresAt,
    this.trialEndsAt,
    required this.createdAt,
  });

  bool get isActive => status.canWrite;

  int get daysRemaining {
    if (status == SubscriptionStatus.trial && trialEndsAt != null) {
      return trialEndsAt!.difference(DateTime.now()).inDays.clamp(0, 999);
    }
    if (expiresAt != null) {
      return expiresAt!.difference(DateTime.now()).inDays.clamp(0, 999);
    }
    return 0;
  }

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json['id'],
        businessId: json['business_id'],
        userId: json['user_id'],
        plan: json['plan'] ?? 'monthly',
        status: SubscriptionStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => SubscriptionStatus.expired,
        ),
        startsAt: json['starts_at'] != null
            ? DateTime.parse(json['starts_at'])
            : null,
        expiresAt: json['expires_at'] != null
            ? DateTime.parse(json['expires_at'])
            : null,
        trialEndsAt: json['trial_ends_at'] != null
            ? DateTime.parse(json['trial_ends_at'])
            : null,
        createdAt: DateTime.parse(json['created_at']),
      );

  @override
  List<Object?> get props => [id, status, expiresAt];
}

class BusinessSummary extends Equatable {
  final double totalPabo;
  final double totalDebo;
  final double todaySales;
  final double todayExpense;

  const BusinessSummary({
    this.totalPabo = 0,
    this.totalDebo = 0,
    this.todaySales = 0,
    this.todayExpense = 0,
  });

  double get netCash => todaySales - todayExpense;

  factory BusinessSummary.fromJson(Map<String, dynamic> json) =>
      BusinessSummary(
        totalPabo: (json['total_pabo'] as num?)?.toDouble() ?? 0,
        totalDebo: (json['total_debo'] as num?)?.toDouble() ?? 0,
        todaySales: (json['today_sales'] as num?)?.toDouble() ?? 0,
        todayExpense: (json['today_expense'] as num?)?.toDouble() ?? 0,
      );

  @override
  List<Object?> get props => [totalPabo, totalDebo, todaySales, todayExpense];
}
