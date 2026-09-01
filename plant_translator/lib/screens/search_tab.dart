import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_outlined,
            size: 80,
            color: AppColors.green400,
          ),
          const SizedBox(height: 16),
          Text(
            'Search Plants',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.green900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search for plants by name, species, or care needs',
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
