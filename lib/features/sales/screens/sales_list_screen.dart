import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SalesListScreen extends StatelessWidget {
  const SalesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('বিক্রির তালিকা')),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}
