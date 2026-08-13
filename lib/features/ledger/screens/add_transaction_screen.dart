import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/models.dart';
import '../../../services/supabase_service.dart';
import '../../../core/utils/formatters.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String? contactId;
  final String? direction;

  const AddTransactionScreen({super.key, this.contactId, this.direction});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  LedgerDirection _direction = LedgerDirection.gave;
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  DateTime _date = DateTime.now();
  bool _isLoading = false;
  String? _selectedContactId;
  Contact? _selectedContact;

  @override
  void initState() {
    super.initState();
    _selectedContactId = widget.contactId;
    if (widget.direction == 'received') {
      _direction = LedgerDirection.received;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedContactId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('একজন কাস্টমার বা সাপ্লায়ার বেছে নিন')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final business = ref.read(currentBusinessProvider)!;
      final amount = double.parse(_amountController.text.replaceAll(',', ''));

      await SupabaseService.createTransaction({
        'business_id': business.id,
        'contact_id': _selectedContactId,
        'direction': _direction.dbValue,
        'amount': amount,
        'date': _date.toIso8601String().split('T')[0],
        'note': _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        'payment_method': _paymentMethod.dbValue,
        'source': 'manual',
        'operation_id': const Uuid().v4(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('লেনদেন সংরক্ষিত হয়েছে ✓')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('সমস্যা হয়েছে: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _direction == LedgerDirection.gave ? 'দিলাম' : 'পেলাম',
          style: TextStyle(
            color: _direction == LedgerDirection.gave
                ? AppColors.debo
                : AppColors.pabo,
          ),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('সংরক্ষণ'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Direction Toggle
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _DirectionButton(
                      label: 'দিলাম (দেবো)',
                      selected: _direction == LedgerDirection.gave,
                      color: AppColors.debo,
                      onTap: () =>
                          setState(() => _direction = LedgerDirection.gave),
                    ),
                  ),
                  Expanded(
                    child: _DirectionButton(
                      label: 'পেলাম (পাবো)',
                      selected: _direction == LedgerDirection.received,
                      color: AppColors.pabo,
                      onTap: () => setState(
                          () => _direction = LedgerDirection.received),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Amount
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: _direction == LedgerDirection.gave
                        ? AppColors.debo
                        : AppColors.pabo,
                  ),
              decoration: InputDecoration(
                labelText: 'পরিমাণ (টাকা)',
                hintText: '0',
                prefixText: '৳ ',
                prefixStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _direction == LedgerDirection.gave
                      ? AppColors.debo
                      : AppColors.pabo,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'পরিমাণ দিন';
                final amount =
                    double.tryParse(v.replaceAll(',', ''));
                if (amount == null || amount <= 0) return 'সঠিক পরিমাণ দিন';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Contact selector
            GestureDetector(
              onTap: () async {
                // Show contact picker bottom sheet
                final contact = await showModalBottomSheet<Contact>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const _ContactPickerSheet(),
                );
                if (contact != null) {
                  setState(() {
                    _selectedContactId = contact.id;
                    _selectedContact = contact;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedContact?.name ?? 'কাস্টমার/সাপ্লায়ার বেছে নিন',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _selectedContact != null
                                  ? AppColors.textPrimary
                                  : AppColors.textHint,
                            ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textHint),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Text(
                      DateFormatter.formatDate(_date),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: AppColors.textHint),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payment method
            Text('পেমেন্ট পদ্ধতি',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: PaymentMethod.values.map((method) {
                final isSelected = _paymentMethod == method;
                return ChoiceChip(
                  label: Text(method.nameBn),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _paymentMethod = method),
                  selectedColor: AppColors.primaryContainer,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primaryDark
                        : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Note
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'নোট (ঐচ্ছিক)',
                hintText: 'বিস্তারিত লিখুন...',
                prefixIcon: Icon(Icons.note_outlined),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _direction == LedgerDirection.gave
                      ? AppColors.debo
                      : AppColors.pabo,
                ),
                child: Text(
                  _direction == LedgerDirection.gave
                      ? 'দিলাম - সংরক্ষণ করুন'
                      : 'পেলাম - সংরক্ষণ করুন',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _DirectionButton({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ContactPickerSheet extends ConsumerWidget {
  const _ContactPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.read(currentBusinessProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('কাস্টমার বেছে নিন',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: business != null
                  ? SupabaseService.getContacts(business.id)
                  : Future.value([]),
              builder: (_, snap) {
                if (!snap.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary));
                }
                final contacts =
                    snap.data!.map((r) => Contact.fromJson(r)).toList();
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (_, i) {
                    final c = contacts[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            AppColors.avatarColors[c.name.codeUnitAt(0) %
                                AppColors.avatarColors.length],
                        child: Text(c.initials,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13)),
                      ),
                      title: Text(c.name),
                      subtitle: Text(c.phone ?? ''),
                      onTap: () => Navigator.pop(context, c),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
