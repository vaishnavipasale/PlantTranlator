import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ScanTab extends StatelessWidget {
  const ScanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 80,
            color: AppColors.teal400,
          ),
          const SizedBox(height: 16),
          Text(
            'Scan Plant',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.green900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Take a photo to identify and analyze your plant',
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
