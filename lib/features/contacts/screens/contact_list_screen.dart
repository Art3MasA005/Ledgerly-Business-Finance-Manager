import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('কাস্টমার ও সাপ্লায়ার')),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}
