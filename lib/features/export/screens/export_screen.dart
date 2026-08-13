import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('রিপোর্ট ডাউনলোড')),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}
