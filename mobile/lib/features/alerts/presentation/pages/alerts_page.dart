import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
      ),
      body: const Center(
        child: Text('Notifications & Alerts Coming Soon', style: TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }
}
