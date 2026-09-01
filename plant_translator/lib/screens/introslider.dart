import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({super.key});

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Auto-play animation controller
  late final AnimationController _autoPlayController;
  
  // Background animation
  late final AnimationController _backgroundController;
  
  // Floating particles animation
  late final AnimationController _particleController;
  
  // Shimmer effect
  late final AnimationController _shimmerController;
  
  // Scale animation for decorative elements
  late final AnimationController _scaleController;
  
  // Rotation animation for decorative elements
  late final AnimationController _rotationController;
  
  // Fade animation for slide transitions
  late final AnimationController _fadeController;

  final List<SlideData> _slides = [
    SlideData(
      icon: Icons.eco_outlined,
      title: 'Welcome to Plant Translator',
      description: 'Discover what your plants are trying to tell you. Unlock the secrets of nature with our advanced AI-powered translation.',
      color: AppColors.green500,
      secondaryColor: AppColors.lime400,
    ),
    SlideData(
      icon: Icons.camera_alt_outlined,
      title: 'Snap & Translate',
      description: 'Simply take a photo of your plant and let our intelligent system identify health issues, care needs, and growth patterns.',
      color: AppColors.teal500,
      secondaryColor: AppColors.cyan400,
    ),
    SlideData(
      icon: Icons.favorite_outlined,
      title: 'Personalized Care',
      description: 'Get tailored recommendations for watering, sunlight, and fertilization based on your specific plant species and environment.',
      color: AppColors.lime500,
      secondaryColor: AppColors.green400,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _autoPlayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
      if (_autoPlayController.status == AnimationStatus.completed) {
        _autoPlayController.reset();
        if (_currentPage < _slides.length - 1) {
          _currentPage++;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        } else {
          _autoPlayController.stop();
        }
        _autoPlayController.forward();
      }
    })..forward();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoPlayController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _skipToLogin() {
    Navigator.of(context).pushReplacementNamed('/');
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
                  _buildFloatingBlob(
                    alignment: Alignment.center,
                    size: 100 * blobScale,
                    color: AppColors.teal400,
                    controller: _scaleController,
                    offset: 0.5,
                  ),
                  _buildFloatingBlob(
                    alignment: Alignment(-0.5, -0.3),
                    size: 80 * blobScale,
                    color: AppColors.violet400,
                    controller: _rotationController,
                    offset: 0.2,
                  ),
                  _buildFloatingBlob(
                    alignment: Alignment(0.5, 0.3),
                    size: 70 * blobScale,
                    color: AppColors.pink400,
                    controller: _rotationController,
                    offset: 0.7,
                  ),
                ],
              );
            },
          ),
          // Main content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final isMobile = screenWidth < 600;
                final isTablet = screenWidth >= 600 && screenWidth < 900;
                
                final iconSize = isMobile ? 120.0 : (isTablet ? 150.0 : 180.0);
                final titleFontSize = isMobile ? 28.0 : (isTablet ? 34.0 : 40.0);
                final subtitleFontSize = isMobile ? 15.0 : (isTablet ? 17.0 : 19.0);

                return Column(
                  children: [
                    // Skip button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 16),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, child) {
                            final shimmerValue = _shimmerController.value;
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color.lerp(
                                    AppColors.green600,
                                    AppColors.green400,
                                    shimmerValue,
                                  )!,
                                  width: 1.5,
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.green50.withOpacity(0.3),
                                    AppColors.green100.withOpacity(0.4),
                                    AppColors.green50.withOpacity(0.3),
                                  ],
                                ),
                              ),
                              child: TextButton(
                                onPressed: _skipToLogin,
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.green700,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontSize: isMobile ? 15 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    // PageView
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                          _autoPlayController.reset();
                          _autoPlayController.forward();
                        },
                        itemCount: _slides.length,
                        itemBuilder: (context, index) {
                          return _buildSlide(
                            _slides[index],
                            iconSize,
                            titleFontSize,
                            subtitleFontSize,
                            isMobile,
                          );
                        },
                      ),
                    ),
                    
                    // Page indicators
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: isMobile ? 24 : 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _slides.length,
                          (index) => _buildPageIndicator(index, isMobile),
                        ),
                      ),
                    ),
                    
                    // Get Started button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 32,
                        vertical: isMobile ? 16 : 24,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: isMobile ? 54 : 60,
                        child: AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, child) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(isMobile ? 16 : 18),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.green500,
                                    AppColors.green600,
                                    AppColors.green700,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.green500.withOpacity(0.5),
                                    blurRadius: isMobile ? 28 : 36,
                                    offset: Offset(0, isMobile ? 10 : 14),
                                  ),
                                  BoxShadow(
                                    color: AppColors.green400.withOpacity(0.4),
                                    blurRadius: isMobile ? 16 : 22,
                                    offset: Offset(0, isMobile ? 6 : 10),
                                  ),
                                  BoxShadow(
                                    color: AppColors.lime400.withOpacity(0.3),
                                    blurRadius: isMobile ? 10 : 14,
                                    offset: Offset(0, isMobile ? 3 : 5),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(isMobile ? 16 : 18),
                                  onTap: _skipToLogin,
                                  child: Center(
                                    child: Text(
                                      _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                                      style: TextStyle(
                                        fontSize: isMobile ? 16 : 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(SlideData slide, double iconSize, double titleFontSize, double subtitleFontSize, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          AnimatedBuilder(
            animation: Listenable.merge([_shimmerController, _rotationController]),
            builder: (context, child) {
              final shimmerValue = _shimmerController.value;
              final rotationValue = _rotationController.value;
              return Transform.rotate(
                angle: rotationValue * math.pi * 0.1,
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(iconSize * 0.35),
                    gradient: LinearGradient(
                      begin: Alignment(-1 + shimmerValue * 2, -1),
                      end: Alignment(1 - shimmerValue * 2, 1),
                      colors: [
                        slide.secondaryColor,
                        slide.color,
                        AppColors.green600,
                        slide.secondaryColor,
                      ],
                      stops: const [0.0, 0.33, 0.66, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: slide.color.withOpacity(0.7),
                        blurRadius: 50 * (iconSize / 120),
                        spreadRadius: 5,
                        offset: const Offset(0, 15),
                      ),
                      BoxShadow(
                        color: slide.secondaryColor.withOpacity(0.5),
                        blurRadius: 30 * (iconSize / 120),
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: AppColors.teal400.withOpacity(0.4),
                        blurRadius: 20 * (iconSize / 120),
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 15 * (iconSize / 120),
                        offset: const Offset(-5, -5),
                      ),
                    ],
                  ),
                  child: Icon(
                    slide.icon,
                    color: Colors.white,
                    size: iconSize * 0.48,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: isMobile ? 32 : 40),
          
          // Title
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              final shimmerValue = _shimmerController.value;
              return ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment(-1 + shimmerValue * 2, 0),
                  end: Alignment(1 - shimmerValue * 2, 0),
                  colors: [
                    AppColors.green900,
                    AppColors.green700,
                    AppColors.green600,
                    slide.color,
                    AppColors.green900,
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ).createShader(bounds),
                child: Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.0,
                    height: 1.15,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: isMobile ? 16 : 20),
          
          // Description
          AnimatedBuilder(
            animation: Listenable.merge([_scaleController, _shimmerController]),
            builder: (context, child) {
              final scaleValue = _scaleController.value;
              final shimmerValue = _shimmerController.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + shimmerValue * 0.5, 0),
                    end: Alignment(1 - shimmerValue * 0.5, 0),
                    colors: [
                      slide.color.withOpacity(0.15 + scaleValue * 0.05),
                      AppColors.green100.withOpacity(0.4 + scaleValue * 0.1),
                      AppColors.green200.withOpacity(0.3 + scaleValue * 0.1),
                      slide.color.withOpacity(0.15 + scaleValue * 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: slide.color.withOpacity(0.4 + scaleValue * 0.1),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: slide.color.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(-3, -3),
                    ),
                  ],
                ),
                child: Text(
                  slide.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: AppColors.green800,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index, bool isMobile) {
    final isActive = index == _currentPage;
    final slide = _slides[index];
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final shimmerValue = _shimmerController.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: isMobile ? 5 : 7),
          width: isActive ? (isMobile ? 28 : 36) : (isMobile ? 10 : 12),
          height: isMobile ? 10 : 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isMobile ? 5 : 6),
            gradient: LinearGradient(
              begin: Alignment(-1 + shimmerValue * 0.5, 0),
              end: Alignment(1 - shimmerValue * 0.5, 0),
              colors: isActive
                  ? [slide.color, slide.secondaryColor]
                  : [AppColors.green200, AppColors.green300],
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: slide.color.withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color: slide.secondaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      },
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

class SlideData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color secondaryColor;

  SlideData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.secondaryColor,
  });
}