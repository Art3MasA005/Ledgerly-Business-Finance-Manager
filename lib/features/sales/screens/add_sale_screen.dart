import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AddSaleScreen extends StatelessWidget {
  const AddSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('বিক্রি যোগ')),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}
