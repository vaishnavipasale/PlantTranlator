import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {
  // Shimmer effect for active items
  late final AnimationController _shimmerController;
  
  // Pulse animation for active items
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 600;
        final isTablet = screenWidth >= 600 && screenWidth < 900;
        
        final horizontalPadding = isMobile ? 8.0 : (isTablet ? 16.0 : 24.0);
        final verticalPadding = isMobile ? 8.0 : (isTablet ? 12.0 : 16.0);
        final iconSize = isMobile ? 24.0 : (isTablet ? 28.0 : 32.0);
        final fontSize = isMobile ? 12.0 : (isTablet ? 13.0 : 14.0);
        final containerPadding = isMobile ? 8.0 : (isTablet ? 10.0 : 12.0);
        final borderRadius = isMobile ? 12.0 : (isTablet ? 14.0 : 16.0);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.98),
                AppColors.green50.withOpacity(0.95),
                Colors.white.withOpacity(0.98),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            border: Border(
              top: BorderSide(
                color: AppColors.green300.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.green600.withOpacity(0.2),
                blurRadius: 25,
                offset: const Offset(0, -6),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
              BoxShadow(
                color: AppColors.lime400.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    index: 0,
                    isActive: widget.currentIndex == 0,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    containerPadding: containerPadding,
                    borderRadius: borderRadius,
                  ),
                  _buildNavItem(
                    icon: Icons.search_outlined,
                    activeIcon: Icons.search,
                    label: 'Search',
                    index: 1,
                    isActive: widget.currentIndex == 1,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    containerPadding: containerPadding,
                    borderRadius: borderRadius,
                  ),
                  _buildNavItem(
                    icon: Icons.camera_alt_outlined,
                    activeIcon: Icons.camera_alt,
                    label: 'Scan',
                    index: 2,
                    isActive: widget.currentIndex == 2,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    containerPadding: containerPadding,
                    borderRadius: borderRadius,
                  ),
                  _buildNavItem(
                    icon: Icons.notifications_outlined,
                    activeIcon: Icons.notifications,
                    label: 'Alerts',
                    index: 3,
                    isActive: widget.currentIndex == 3,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    containerPadding: containerPadding,
                    borderRadius: borderRadius,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    index: 4,
                    isActive: widget.currentIndex == 4,
                    iconSize: iconSize,
                    fontSize: fontSize,
                    containerPadding: containerPadding,
                    borderRadius: borderRadius,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isActive,
    required double iconSize,
    required double fontSize,
    required double containerPadding,
    required double borderRadius,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => widget.onTap(index),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AnimatedBuilder(
            animation: Listenable.merge([_shimmerController, _pulseController]),
            builder: (context, child) {
              final shimmerValue = _shimmerController.value;
              final pulseValue = _pulseController.value;
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(containerPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      gradient: isActive
                          ? LinearGradient(
                              begin: Alignment(-1 + shimmerValue * 2, -1),
                              end: Alignment(1 - shimmerValue * 2, 1),
                              colors: [
                                AppColors.lime400,
                                AppColors.green500,
                                AppColors.green600,
                                AppColors.lime400,
                              ],
                              stops: const [0.0, 0.33, 0.66, 1.0],
                            )
                          : null,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.green500.withOpacity(0.5 + pulseValue * 0.1),
                                blurRadius: 15 + pulseValue * 5,
                                offset: const Offset(0, 5),
                              ),
                              BoxShadow(
                                color: AppColors.lime400.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(-2, -2),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      isActive ? activeIcon : icon,
                      color: isActive ? Colors.white : AppColors.stone400,
                      size: iconSize,
                    ),
                  ),
                  SizedBox(height: fontSize * 0.4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? AppColors.green700 : AppColors.stone400,
                      letterSpacing: isActive ? 0.3 : 0.0,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
