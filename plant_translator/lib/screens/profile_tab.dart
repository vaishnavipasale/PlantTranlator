import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: AppColors.cyan400,
          ),
          const SizedBox(height: 16),
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.green900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your account and preferences',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.stone600,
            ),
          ),
        ],
      ),
    );
  }
}
