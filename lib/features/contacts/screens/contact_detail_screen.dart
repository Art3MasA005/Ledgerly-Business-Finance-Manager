import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ContactDetailScreen extends StatelessWidget {
  final String contactId;
  const ContactDetailScreen({super.key, required this.contactId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('বিস্তারিত')),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}
