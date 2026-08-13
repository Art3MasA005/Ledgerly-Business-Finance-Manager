import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ImportScreen extends StatelessWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('ডাটা আমদানি')),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}
