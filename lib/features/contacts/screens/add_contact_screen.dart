import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AddContactScreen extends StatelessWidget {
  const AddContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('কাস্টমার যোগ')),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}
