import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/plant.dart';
import '../services/plant_service.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  final PlantService _plantService = PlantService();
  List<Plant> _plants = [];
  bool _isLoading = true;

  // Background animation
  late final AnimationController _backgroundController;
  
  // Floating particles animation
  late final AnimationController _particleController;
  
  // Shimmer effect
  late final AnimationController _shimmerController;
  
  // Scale animation for decorative elements
  late final AnimationController _scaleController;
  
  // Pulse animation for cards
  late final AnimationController _pulseController;
  
  // Rotation animation for decorative elements
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _loadPlants();
    
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

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  Future<void> _loadPlants() async {
    final plants = await _plantService.getPlants();
    setState(() {
      _plants = plants;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  color: AppColors.violet400,
                  controller: _rotationController,
                  offset: 0.5,
                ),
                _buildFloatingBlob(
                  alignment: Alignment(-0.3, 0.7),
                  size: 80 * blobScale,
                  color: AppColors.pink400,
                  controller: _rotationController,
                  offset: 0.2,
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
              
              final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);
              final padding = isMobile ? 16.0 : (isTablet ? 24.0 : 32.0);

              return Column(
                children: [
                  // Header
                  _buildHeader(isMobile, padding),
                  
                  // Plants grid
                  Expanded(
                    child: _isLoading
                        ? _buildLoadingIndicator()
                        : _buildPlantsGrid(crossAxisCount, padding, isMobile),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isMobile, double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          // Logo
          AnimatedBuilder(
            animation: Listenable.merge([_shimmerController, _pulseController]),
            builder: (context, child) {
              final shimmerValue = _shimmerController.value;
              final pulseValue = _pulseController.value;
              return Container(
                width: isMobile ? 48 : 56,
                height: isMobile ? 48 : 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
                  gradient: LinearGradient(
                    begin: Alignment(-1 + shimmerValue * 2, -1),
                    end: Alignment(1 - shimmerValue * 2, 1),
                    colors: [
                      AppColors.lime400,
                      AppColors.green400,
                      AppColors.green500,
                      AppColors.lime400,
                    ],
                    stops: const [0.0, 0.33, 0.66, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green500.withOpacity(0.5 + pulseValue * 0.1),
                      blurRadius: 15 + pulseValue * 5,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppColors.lime400.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.eco_outlined, color: Colors.white, size: isMobile ? 24 : 28),
              );
            },
          ),
          SizedBox(width: isMobile ? 12 : 16),
          
          // Title
          Expanded(
            child: AnimatedBuilder(
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
                      AppColors.teal500,
                      AppColors.green900,
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  ).createShader(bounds),
                  child: Text(
                    'My Plants',
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Add button
          AnimatedBuilder(
            animation: Listenable.merge([_shimmerController, _pulseController]),
            builder: (context, child) {
              final shimmerValue = _shimmerController.value;
              final pulseValue = _pulseController.value;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
                  gradient: LinearGradient(
                    begin: Alignment(-1 + shimmerValue * 2, 0),
                    end: Alignment(1 - shimmerValue * 2, 0),
                    colors: [
                      AppColors.green500,
                      AppColors.green600,
                      AppColors.green500,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green500.withOpacity(0.5 + pulseValue * 0.1),
                      blurRadius: 12 + pulseValue * 4,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppColors.lime400.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    // TODO: Navigate to add plant page
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.green600,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildPlantsGrid(int crossAxisCount, double padding, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: isMobile ? 12 : 16,
          mainAxisSpacing: isMobile ? 12 : 16,
          childAspectRatio: isMobile ? 0.75 : 0.8,
        ),
        itemCount: _plants.length,
        itemBuilder: (context, index) {
          return _buildPlantCard(_plants[index], isMobile);
        },
      ),
    );
  }

  Widget _buildPlantCard(Plant plant, bool isMobile) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _shimmerController, _pulseController]),
      builder: (context, child) {
        final scaleValue = _scaleController.value;
        final shimmerValue = _shimmerController.value;
        final pulseValue = _pulseController.value;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
            gradient: LinearGradient(
              begin: Alignment(-1 + shimmerValue * 0.5, -1),
              end: Alignment(1 - shimmerValue * 0.5, 1),
              colors: [
                Colors.white.withOpacity(0.98),
                AppColors.green50.withOpacity(0.95),
                AppColors.green100.withOpacity(0.9),
                Colors.white.withOpacity(0.98),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
            border: Border.all(
              color: AppColors.green300.withOpacity(0.5 + scaleValue * 0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.green600.withOpacity(0.25 + pulseValue * 0.05),
                blurRadius: 20 + pulseValue * 5,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                blurRadius: 15,
                offset: const Offset(-3, -3),
              ),
              BoxShadow(
                color: AppColors.lime400.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Plant image
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-1 + shimmerValue * 0.5, -1),
                        end: Alignment(1 - shimmerValue * 0.5, 1),
                        colors: [
                          AppColors.green100,
                          AppColors.green200,
                          AppColors.lime400.withOpacity(0.3),
                          AppColors.green100,
                        ],
                        stops: const [0.0, 0.4, 0.7, 1.0],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final pulse = _pulseController.value;
                              return Transform.scale(
                                scale: 1.0 + pulse * 0.05,
                                child: Icon(
                                  Icons.eco_outlined,
                                  size: isMobile ? 48 : 56,
                                  color: AppColors.green600,
                                ),
                              );
                            },
                          ),
                        ),
                        // Health indicator badge
                        Positioned(
                          top: isMobile ? 8 : 12,
                          right: isMobile ? 8 : 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 6 : 8,
                              vertical: isMobile ? 3 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getHealthColor(plant.healthScore),
                              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                              boxShadow: [
                                BoxShadow(
                                  color: _getHealthColor(plant.healthScore).withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: isMobile ? 10 : 12,
                                  color: Colors.white,
                                ),
                                SizedBox(width: isMobile ? 2 : 3),
                                Text(
                                  '${plant.healthScore}%',
                                  style: TextStyle(
                                    fontSize: isMobile ? 10 : 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Plant info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.name,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.green900,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isMobile ? 4 : 6),
                        Text(
                          plant.species,
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.stone600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isMobile ? 4 : 5),
                              decoration: BoxDecoration(
                                color: AppColors.cyan500.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                              ),
                              child: Icon(
                                Icons.water_drop_outlined,
                                size: isMobile ? 14 : 16,
                                color: AppColors.cyan500,
                              ),
                            ),
                            SizedBox(width: isMobile ? 6 : 8),
                            Expanded(
                              child: Text(
                                _getWateringText(plant.nextWatering),
                                style: TextStyle(
                                  fontSize: isMobile ? 11 : 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.stone600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getWateringText(DateTime nextWatering) {
    final days = nextWatering.difference(DateTime.now()).inDays;
    if (days <= 0) return 'Water today';
    if (days == 1) return 'Water tomorrow';
    return 'Water in $days days';
  }

  Color _getHealthColor(int score) {
    if (score >= 90) return AppColors.green500;
    if (score >= 70) return AppColors.lime500;
    if (score >= 50) return AppColors.teal500;
    return AppColors.rose500;
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
