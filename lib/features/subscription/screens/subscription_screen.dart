import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('সাবস্ক্রিপশন')),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}
