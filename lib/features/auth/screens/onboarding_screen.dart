import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/supabase_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedType = 'grocery';
  bool _isLoading = false;

  final List<Map<String, String>> _businessTypes = [
    {'key': 'grocery', 'icon': '🛒', 'label': 'মুদি দোকান'},
    {'key': 'pharmacy', 'icon': '💊', 'label': 'ফার্মেসি'},
    {'key': 'hardware', 'icon': '🔧', 'label': 'হার্ডওয়্যার'},
    {'key': 'cosmetics', 'icon': '💄', 'label': 'কসমেটিক্স'},
    {'key': 'electronics', 'icon': '📱', 'label': 'ইলেকট্রনিক্স'},
    {'key': 'clothing', 'icon': '👕', 'label': 'কাপড়'},
    {'key': 'food', 'icon': '🍽️', 'label': 'খাবার'},
    {'key': 'service', 'icon': '🛠️', 'label': 'সেবা'},
    {'key': 'wholesale', 'icon': '📦', 'label': 'পাইকারি'},
    {'key': 'other', 'icon': '🏪', 'label': 'অন্যান্য'},
  ];

  Future<void> _createBusiness() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = SupabaseService.currentUser!;
      await ref.read(currentBusinessProvider.notifier).create({
        'owner_id': user.id,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        'address': _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        'business_type': _selectedType,
      });

      // Create initial subscription (trial)
      final business = ref.read(currentBusinessProvider)!;
      await SupabaseService.createSubscription({
        'business_id': business.id,
        'user_id': user.id,
        'plan': 'monthly',
        'status': 'trial',
      });

      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ব্যবসা তৈরি করতে সমস্যা হয়েছে: $e')),
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'আপনার ব্যবসার তথ্য',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('প্রথমে আপনার দোকান বা ব্যবসার তথ্য দিন',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'ব্যবসার নাম *',
                          hintText: 'যেমন: Yeasir Traders',
                          prefixIcon: Icon(Icons.store_outlined),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'ব্যবসার নাম দিন' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'ফোন নম্বর',
                          hintText: '01XXXXXXXXX',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'ঠিকানা',
                          hintText: 'দোকানের ঠিকানা',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('ব্যবসার ধরন',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _businessTypes.map((type) {
                          final isSelected = _selectedType == type['key'];
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedType = type['key']!),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryContainer
                                    : AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.divider,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(type['icon']!,
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 6),
                                  Text(
                                    type['label']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? AppColors.primaryDark
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 36),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _createBusiness,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text('শুরু করুন →'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          '৭ দিনের বিনামূল্যে ট্রায়াল শুরু হবে',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textHint),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
