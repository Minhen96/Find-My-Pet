import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CommunityFeedPage extends StatelessWidget {
  const CommunityFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Feed'),
      ),
      body: const Center(
        child: Text('Community Feed Coming Soon', style: TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }
}
