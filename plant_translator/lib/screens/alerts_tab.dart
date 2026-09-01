import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_outlined,
            size: 80,
            color: AppColors.lime400,
          ),
          const SizedBox(height: 16),
          Text(
            'Plant Alerts',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.green900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get notified about watering schedules and plant health',
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
