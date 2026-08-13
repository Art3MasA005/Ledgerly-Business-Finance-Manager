import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('পেমেন্ট')),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}
