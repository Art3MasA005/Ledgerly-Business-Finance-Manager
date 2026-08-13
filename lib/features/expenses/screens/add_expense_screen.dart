import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('খরচ যোগ')),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}
