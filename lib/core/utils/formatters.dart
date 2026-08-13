import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _bdtFormat = NumberFormat('#,##,##0.##', 'en_IN');
  static final NumberFormat _bdtFormatFull = NumberFormat('#,##,##0.00', 'en_IN');

  /// Format amount in BDT style (e.g. 1,50,000.00)
  static String format(double amount, {bool showDecimal = true}) {
    return showDecimal
        ? _bdtFormatFull.format(amount)
        : _bdtFormat.format(amount);
  }

  /// Format with ৳ symbol
  static String formatWithSymbol(double amount) {
    return '৳${_bdtFormatFull.format(amount)}';
  }

  /// Format for display (compact: 1.5L, 30K etc)
  static String formatCompact(double amount) {
    if (amount >= 10000000) return '${(amount / 10000000).toStringAsFixed(1)} কোটি';
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)} লক্ষ';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return format(amount);
  }

  /// Parse a formatted currency string back to double
  static double? parse(String value) {
    try {
      final cleaned = value
          .replaceAll('৳', '')
          .replaceAll(',', '')
          .trim();
      return double.tryParse(cleaned);
    } catch (_) {
      return null;
    }
  }
}

class DateFormatter {
  static final DateFormat _dateFormatEn = DateFormat('dd MMM yyyy');
  static final DateFormat _dateFormatShortEn = DateFormat('dd MMM');

  static const Map<int, String> _bnMonths = {
    1: 'জানুয়ারি', 2: 'ফেব্রুয়ারি', 3: 'মার্চ',
    4: 'এপ্রিল', 5: 'মে', 6: 'জুন',
    7: 'জুলাই', 8: 'আগস্ট', 9: 'সেপ্টেম্বর',
    10: 'অক্টোবর', 11: 'নভেম্বর', 12: 'ডিসেম্বর',
  };

  static const Map<int, String> _bnMonthsShort = {
    1: 'জান', 2: 'ফেব', 3: 'মার', 4: 'এপ্র',
    5: 'মে', 6: 'জুন', 7: 'জুলাই', 8: 'আগ',
    9: 'সেপ', 10: 'অক্টো', 11: 'নভে', 12: 'ডিসে',
  };

  static String formatDate(DateTime date, {bool bangla = true}) {
    if (bangla) {
      return '${_toBengaliNumeral(date.day)} ${_bnMonths[date.month]} ${_toBengaliNumeral(date.year)}';
    }
    return _dateFormatEn.format(date);
  }

  static String formatShortDate(DateTime date, {bool bangla = true}) {
    if (bangla) {
      return '${_toBengaliNumeral(date.day)} ${_bnMonthsShort[date.month]}';
    }
    return _dateFormatShortEn.format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'আজ';
    if (diff.inDays == 1) return 'গতকাল';
    if (diff.inDays < 7) return '${_toBengaliNumeral(diff.inDays)} দিন আগে';
    if (diff.inDays < 30) return '${_toBengaliNumeral((diff.inDays / 7).floor())} সপ্তাহ আগে';
    if (diff.inDays < 365) return '${_toBengaliNumeral((diff.inDays / 30).floor())} মাস আগে';
    return formatShortDate(date);
  }

  static String _toBengaliNumeral(int n) {
    const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return n.toString().split('').map((d) => bnDigits[int.parse(d)]).join();
  }
}

class PhoneUtils {
  /// Normalize Bangladeshi phone number to 01XXXXXXXXX format
  static String? normalize(String? phone) {
    if (phone == null || phone.isEmpty) return null;

    // Remove spaces, dashes, dots
    String cleaned = phone.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');

    // Remove country code variants
    if (cleaned.startsWith('+880')) cleaned = '0${cleaned.substring(4)}';
    if (cleaned.startsWith('880')) cleaned = '0${cleaned.substring(3)}';

    // Validate: must be 11 digits starting with 01
    if (RegExp(r'^01[3-9]\d{8}$').hasMatch(cleaned)) return cleaned;
    return null;
  }

  /// Check if two phone numbers are the same (normalized)
  static bool isSame(String? a, String? b) {
    final na = normalize(a);
    final nb = normalize(b);
    if (na == null || nb == null) return false;
    return na == nb;
  }

  /// Format for display: 01XXX-XXXXXX
  static String formatDisplay(String phone) {
    final normalized = normalize(phone) ?? phone;
    if (normalized.length == 11) {
      return '${normalized.substring(0, 5)}-${normalized.substring(5)}';
    }
    return phone;
  }
}
