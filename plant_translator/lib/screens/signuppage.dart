import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isButtonPressed = false;
  String? _errorText;

  // Entrance choreography for the whole form.
  late final AnimationController _entranceController;
  // Slow ambient drift for the background gradient.
  late final AnimationController _backgroundController;
  // Gentle floating/rotation loop for the hero icon.
  late final AnimationController _logoLoopController;
  // Short horizontal shake played on validation / signup failure.
  late final AnimationController _shakeController;
  // Pulsing glow effect for the card
  late final AnimationController _pulseController;
  // Floating particles animation
  late final AnimationController _particleController;
  // Shimmer effect for buttons
  late final AnimationController _shimmerController;
  // Scale animation for decorative elements
  late final AnimationController _scaleController;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _logoLoopController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _entranceController.dispose();
    _backgroundController.dispose();
    _logoLoopController.dispose();
    _shakeController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  // Builds a fade + upward-slide animation for a slice of the entrance
  // timeline, so fields cascade in one after another instead of popping
  // in all at once.
  Animation<double> _fade(double start, double end) {
    return CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  Animation<Offset> _slideUp(double start, double end) {
    return Tween<Offset>(begin: const Offset(0, 0.16), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  Widget _staggered({
    required double start,
    required double end,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: _fade(start, end),
      child: SlideTransition(position: _slideUp(start, end), child: child),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your name';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your email';
    final pattern = RegExp(r'^[\w.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!pattern.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _playShake() async {
    _shakeController.reset();
    await _shakeController.forward();
  }

  Future<void> _handleSignup() async {
    setState(() => _errorText = null);
    if (!_formKey.currentState!.validate()) {
      _playShake();
      return;
    }

    setState(() => _isLoading = true);

    // Replace this with your real auth call (Firebase Auth, your API, etc).
    try {
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      setState(() => _errorText = "Couldn't create account. Check your details and try again.");
      _playShake();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                ],
              );
            },
          ),
          // Main content
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
                child: child,
              );
            },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isMobile = screenWidth < 600;
              final isTablet = screenWidth >= 600 && screenWidth < 900;
              final isDesktop = screenWidth >= 900;
              
              final outerPadding = isMobile ? 16.0 : (isTablet ? 24.0 : 32.0);
              final cardPadding = isMobile ? 20.0 : (isTablet ? 28.0 : 36.0);
              final cardMaxWidth = isDesktop ? 450.0 : 380.0;
              final iconSize = isMobile ? 72.0 : (isTablet ? 80.0 : 88.0);
              final titleFontSize = isMobile ? 28.0 : (isTablet ? 32.0 : 36.0);
              final subtitleFontSize = isMobile ? 14.0 : (isTablet ? 15.0 : 16.0);

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: outerPadding, vertical: 32),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: cardMaxWidth),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_shakeController, _pulseController]),
                      builder: (context, child) {
                        final shake = math.sin(_shakeController.value * math.pi * 6) *
                            (1 - _shakeController.value) *
                            10;
                        final pulse = 1.0 + (_pulseController.value * 0.03);
                        return Transform.translate(
                          offset: Offset(shake, 0),
                          child: Transform.scale(scale: pulse, child: child),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(cardPadding, cardPadding + 4, cardPadding, cardPadding),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.98),
                              AppColors.green50.withOpacity(0.95),
                              Colors.white.withOpacity(0.98),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(isMobile ? 28 : 36),
                          border: Border.all(
                            color: AppColors.green300.withOpacity(0.7),
                            width: isMobile ? 2.0 : 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.green600.withOpacity(0.3),
                              blurRadius: isMobile ? 50 : 70,
                              offset: Offset(0, isMobile ? 20 : 30),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: AppColors.green400.withOpacity(0.2),
                              blurRadius: isMobile ? 30 : 40,
                              offset: Offset(0, isMobile ? 10 : 15),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.9),
                              blurRadius: isMobile ? 20 : 30,
                              offset: const Offset(-8, -8),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: AppColors.lime400.withOpacity(0.15),
                              blurRadius: isMobile ? 25 : 35,
                              offset: const Offset(5, 5),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [

                        // Floating, gently rotating hero icon with a soft glow.
                        _staggered(
                          start: 0.0,
                          end: 0.5,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _logoLoopController,
                              builder: (context, child) {
                                final v = _logoLoopController.value;
                                final dy = math.sin(v * math.pi) * 4;
                                final rotation = (v - 0.5) * 0.08;
                                return Transform.translate(
                                  offset: Offset(0, -dy),
                                  child: Transform.rotate(angle: rotation, child: child),
                                );
                              },
                              child: AnimatedBuilder(
                                animation: _shimmerController,
                                builder: (context, child) {
                                  final shimmerValue = _shimmerController.value;
                                  return Container(
                                    width: iconSize,
                                    height: iconSize,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(iconSize * 0.35),
                                      gradient: LinearGradient(
                                        begin: Alignment(-1 + shimmerValue * 2, -1),
                                        end: Alignment(1 - shimmerValue * 2, 1),
                                        colors: [
                                          AppColors.lime400,
                                          AppColors.green400,
                                          AppColors.green500,
                                          AppColors.green600,
                                          AppColors.lime400,
                                        ],
                                        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.green500.withOpacity(0.7),
                                          blurRadius: 40 * (iconSize / 80),
                                          spreadRadius: 4,
                                          offset: const Offset(0, 12),
                                        ),
                                        BoxShadow(
                                          color: AppColors.lime400.withOpacity(0.5),
                                          blurRadius: 25 * (iconSize / 80),
                                          offset: const Offset(0, 6),
                                        ),
                                        BoxShadow(
                                          color: AppColors.teal400.withOpacity(0.3),
                                          blurRadius: 15 * (iconSize / 80),
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Icon(Icons.eco_outlined, color: Colors.white, size: iconSize * 0.48),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        _staggered(
                          start: 0.08,
                          end: 0.55,
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
                                  'Create account',
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
                        ),
                        const SizedBox(height: 6),
                        _staggered(
                          start: 0.14,
                          end: 0.6,
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              final pulseValue = _pulseController.value;
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.green100.withOpacity(0.4 + pulseValue * 0.1),
                                      AppColors.green200.withOpacity(0.3 + pulseValue * 0.1),
                                      AppColors.green300.withOpacity(0.2 + pulseValue * 0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.green200.withOpacity(0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'Join us and start translating your plants.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Georgia',
                                    fontStyle: FontStyle.italic,
                                    fontSize: subtitleFontSize,
                                    color: AppColors.green800,
                                    height: 1.4,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),

                        _staggered(
                          start: 0.22,
                          end: 0.68,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _FieldLabel('Name'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                autofillHints: const [AutofillHints.name],
                                validator: _validateName,
                                style: TextStyle(fontSize: isMobile ? 14 : 15),
                                decoration: _inputDecoration('John Doe', isMobile: isMobile),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        _staggered(
                          start: 0.3,
                          end: 0.76,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _FieldLabel('Email'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                validator: _validateEmail,
                                style: TextStyle(fontSize: isMobile ? 14 : 15),
                                decoration: _inputDecoration('name@example.com', isMobile: isMobile),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        _staggered(
                          start: 0.38,
                          end: 0.82,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _FieldLabel('Password'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                autofillHints: const [AutofillHints.password],
                                validator: _validatePassword,
                                style: TextStyle(fontSize: isMobile ? 14 : 15),
                                decoration: _inputDecoration('••••••••', isMobile: isMobile).copyWith(
                                  suffixIcon: IconButton(
                                    icon: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      transitionBuilder: (child, anim) =>
                                          ScaleTransition(scale: anim, child: child),
                                      child: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        key: ValueKey(_obscurePassword),
                                        color: AppColors.stone400,
                                        size: 20,
                                      ),
                                    ),
                                    onPressed: () =>
                                        setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        _staggered(
                          start: 0.46,
                          end: 0.88,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _FieldLabel('Confirm Password'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                autofillHints: const [AutofillHints.password],
                                validator: _validateConfirmPassword,
                                style: TextStyle(fontSize: isMobile ? 14 : 15),
                                decoration: _inputDecoration('••••••••', isMobile: isMobile).copyWith(
                                  suffixIcon: IconButton(
                                    icon: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      transitionBuilder: (child, anim) =>
                                          ScaleTransition(scale: anim, child: child),
                                      child: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        key: ValueKey(_obscureConfirmPassword),
                                        color: AppColors.stone400,
                                        size: 20,
                                      ),
                                    ),
                                    onPressed: () =>
                                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          alignment: Alignment.topCenter,
                          child: _errorText == null
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline, size: 15, color: AppColors.rose600),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          _errorText!,
                                          style: const TextStyle(color: AppColors.rose600, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),

                        const SizedBox(height: 12),
                        _staggered(
                          start: 0.52,
                          end: 0.95,
                          child: GestureDetector(
                            onTapDown: (_) => setState(() => _isButtonPressed = true),
                            onTapUp: (_) => setState(() => _isButtonPressed = false),
                            onTapCancel: () => setState(() => _isButtonPressed = false),
                            child: AnimatedScale(
                              scale: _isButtonPressed ? 0.97 : 1.0,
                              duration: const Duration(milliseconds: 120),
                              curve: Curves.easeOut,
                              child: SizedBox(
                                height: isMobile ? 50 : 56,
                                child: DecoratedBox(
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
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: _isLoading ? null : _handleSignup,
                                      child: Center(
                                        child: AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 200),
                                          child: _isLoading
                                              ? const SizedBox(
                                                  key: ValueKey('loading'),
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.4,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Text(
                                                  'Create account',
                                                  key: ValueKey('label'),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        _staggered(
                          start: 0.58,
                          end: 1.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? ",
                                  style: TextStyle(color: AppColors.stone600, fontSize: 13)),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: AppColors.emerald700,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                            ],
                          ), // Column
                        ), // Form
                      ), // Container (card)
                    ), // AnimatedBuilder (shake)
                  ), // ConstrainedBox
                ), // SingleChildScrollView
              ); // Center
            },
          ), // LayoutBuilder
        ), // SafeArea
          ), // AnimatedBuilder (background)
        ], // Stack children
      ), // Stack
    );
  }

  InputDecoration _inputDecoration(String hint, {bool isMobile = true}) {
    final borderRadius = isMobile ? 14.0 : 16.0;
    final contentPadding = isMobile 
        ? const EdgeInsets.symmetric(horizontal: 14, vertical: 14)
        : const EdgeInsets.symmetric(horizontal: 18, vertical: 18);
    final fontSize = isMobile ? 14.0 : 15.0;
    
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.stone400, fontSize: fontSize),
      filled: true,
      fillColor: AppColors.green50.withOpacity(0.5),
      contentPadding: contentPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: AppColors.green200.withOpacity(0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: AppColors.green200.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: AppColors.green600, width: isMobile ? 2.0 : 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.rose600),
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Text(
          text,
          style: TextStyle(
            fontSize: isMobile ? 13 : 14,
            color: AppColors.green800,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        );
      },
    );
  }
}
