import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_tab.dart';
import 'search_tab.dart';
import 'scan_tab.dart';
import 'alerts_tab.dart';
import 'profile_tab.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key, this.initialIndex = 0});

  /// Which bottom-nav tab to open on. 0=Home, 1=Search, 2=Scan, 3=Alerts, 4=Profile.
  final int initialIndex;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> with TickerProviderStateMixin {
  late int _currentIndex = widget.initialIndex;

  // Background animation
  late final AnimationController _backgroundController;
  
  // Floating particles animation
  late final AnimationController _particleController;

  final List<Widget> _tabs = [
    const HomeTab(),
    const SearchTab(),
    const ScanTab(),
    const AlertsTab(),
    const ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  void _onNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stone50,
      body: Stack(
        children: [
          // Animated background gradient
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              final t = _backgroundController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + t * 0.6, -1 + t * 0.3),
                    end: Alignment(1 - t * 0.3, 1 - t * 0.6),
                    colors: [
                      AppColors.green50,
                      Color.lerp(AppColors.green100, AppColors.green200, t)!,
                      Color.lerp(AppColors.green300, AppColors.green400, t)!,
                      AppColors.green50,
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              );
            },
          ),
          // Floating decorative blobs
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final blobScale = screenWidth < 600 ? 0.6 : (screenWidth < 900 ? 0.8 : 1.0);
              return Stack(
                children: [
                  _buildFloatingBlob(
                    alignment: Alignment.topLeft,
                    size: 150 * blobScale,
                    color: AppColors.green200,
                    controller: _particleController,
                    offset: 0.0,
                  ),
                  _buildFloatingBlob(
                    alignment: Alignment.topRight,
                    size: 120 * blobScale,
                    color: AppColors.lime400,
                    controller: _particleController,
                    offset: 0.3,
                  ),
                  _buildFloatingBlob(
                    alignment: Alignment.bottomLeft,
                    size: 180 * blobScale,
                    color: AppColors.green300,
                    controller: _particleController,
                    offset: 0.6,
                  ),
                  _buildFloatingBlob(
                    alignment: Alignment.bottomRight,
                    size: 140 * blobScale,
                    color: AppColors.cyan400,
                    controller: _particleController,
                    offset: 0.9,
                  ),
                ],
              );
            },
          ),
          // Main content
          IndexedStack(
            index: _currentIndex,
            children: _tabs,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTap,
      ),
    );
  }

  Widget _buildFloatingBlob({
    required Alignment alignment,
    required double size,
    required Color color,
    required AnimationController controller,
    required double offset,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = (controller.value + offset) % 1.0;
        final dx = math.sin(t * math.pi * 2) * 30;
        final dy = math.cos(t * math.pi * 2) * 30;
        final scale = 0.8 + math.sin(t * math.pi * 2) * 0.2;
        return Positioned(
          left: alignment.x >= 0 ? null : 20 + dx,
          right: alignment.x <= 0 ? null : 20 - dx,
          top: alignment.y >= 0 ? null : 80 + dy,
          bottom: alignment.y <= 0 ? null : 80 - dy,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
            ),
          ),
        );
      },
    );
  }
}