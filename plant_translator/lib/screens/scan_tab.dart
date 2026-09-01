import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_colors.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  final ImagePicker _picker = ImagePicker();
  File? _capturedImage;
  bool _isAnalyzing = false;
  bool _hasResult = false;

  bool get _hasCapture => _capturedImage != null;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );

      if (picked == null) return; // user cancelled

      setState(() {
        _capturedImage = File(picked.path);
        _hasResult = false;
        _isAnalyzing = true;
      });

      // TODO: replace with a real analysis / identification API call
      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _hasResult = true;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Couldn\'t open ${source == ImageSource.camera ? 'camera' : 'gallery'}: $e'),
          backgroundColor: AppColors.stone600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _retake() {
    setState(() {
      _capturedImage = null;
      _hasResult = false;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scan Plant',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.green900,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Take a photo to identify and analyze your plant',
                style: TextStyle(fontSize: 13, color: AppColors.stone600),
              ),
              const SizedBox(height: 20),
              _ScanFrame(
                image: _capturedImage,
                isAnalyzing: _isAnalyzing,
              ),
              const SizedBox(height: 20),
              if (!_hasCapture)
                _CaptureActions(
                  onTakePhoto: () => _pickImage(ImageSource.camera),
                  onChooseFromGallery: () => _pickImage(ImageSource.gallery),
                ),
              if (_hasCapture && _isAnalyzing) const _AnalyzingIndicator(),
              if (_hasCapture && _hasResult) _AnalysisResult(onRetake: _retake),
              const SizedBox(height: 28),
              Text(
                'Tips for a good scan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green900,
                ),
              ),
              const SizedBox(height: 10),
              const _TipRow(
                icon: Icons.wb_sunny_outlined,
                text: 'Use natural daylight, avoid harsh shadows',
              ),
              const _TipRow(
                icon: Icons.crop_free,
                text: 'Fill the frame with the whole plant',
              ),
              const _TipRow(
                icon: Icons.center_focus_strong_outlined,
                text: 'Hold steady and keep leaves in focus',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanFrame extends StatelessWidget {
  const _ScanFrame({required this.image, required this.isAnalyzing});

  final File? image;
  final bool isAnalyzing;

  bool get hasCapture => image != null;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.green100, AppColors.teal400.withOpacity(0.15)],
          ),
          border: Border.all(
            color: hasCapture ? AppColors.green500 : AppColors.green200,
            width: hasCapture ? 2 : 1.5,
          ),
        ),
        child: hasCapture
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    image!,
                    fit: BoxFit.cover,
                  ),
                  if (isAnalyzing)
                    Container(
                      color: Colors.black.withOpacity(0.35),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 12),
                            Text(
                              'Analyzing plant…',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!isAnalyzing)
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.green600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 13, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Captured',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.teal400.withOpacity(0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 34,
                            color: AppColors.teal500,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Position your plant here',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.green700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Corner guides
                  ..._cornerGuides(context),
                ],
              ),
      ),
    );
  }

  List<Widget> _cornerGuides(BuildContext context) {
    const size = 26.0;
    const thickness = 3.0;
    final color = AppColors.green500;
    Widget corner({required bool top, required bool left}) {
      return Positioned(
        top: top ? 16 : null,
        bottom: top ? null : 16,
        left: left ? 16 : null,
        right: left ? null : 16,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CornerPainter(color: color, thickness: thickness, top: top, left: left),
          ),
        ),
      );
    }

    return [
      corner(top: true, left: true),
      corner(top: true, left: false),
      corner(top: false, left: true),
      corner(top: false, left: false),
    ];
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter({
    required this.color,
    required this.thickness,
    required this.top,
    required this.left,
  });

  final Color color;
  final double thickness;
  final bool top;
  final bool left;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final horizontalY = top ? 0.0 : size.height;
    final verticalX = left ? 0.0 : size.width;

    canvas.drawLine(Offset(verticalX, horizontalY), Offset(verticalX, horizontalY + (top ? size.height * 0.7 : -size.height * 0.7)), paint);
    canvas.drawLine(Offset(verticalX, horizontalY), Offset(verticalX + (left ? size.width * 0.7 : -size.width * 0.7), horizontalY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CaptureActions extends StatelessWidget {
  const _CaptureActions({
    required this.onTakePhoto,
    required this.onChooseFromGallery,
  });

  final VoidCallback onTakePhoto;
  final VoidCallback onChooseFromGallery;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onTakePhoto,
            icon: const Icon(Icons.camera_alt, size: 20),
            label: const Text('Take Photo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onChooseFromGallery,
            icon: Icon(Icons.photo_library_outlined, size: 20, color: AppColors.green700),
            label: Text('Choose from Gallery', style: TextStyle(color: AppColors.green700)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.green300),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnalyzingIndicator extends StatelessWidget {
  const _AnalyzingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      alignment: Alignment.center,
      child: Text(
        'Hold on, identifying your plant…',
        style: TextStyle(fontSize: 13, color: AppColors.stone600, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _AnalysisResult extends StatelessWidget {
  const _AnalysisResult({required this.onRetake});

  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.green100),
            boxShadow: [
              BoxShadow(
                color: AppColors.stone400.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 18, color: AppColors.lime500),
                  const SizedBox(width: 8),
                  Text(
                    'Analysis complete',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ResultRow(label: 'Identified species', value: 'Monstera deliciosa', color: AppColors.green700),
              const SizedBox(height: 8),
              _ResultRow(label: 'Leaf condition', value: 'Healthy, no issues found', color: AppColors.green600),
              const SizedBox(height: 8),
              _ResultRow(label: 'Confidence', value: '94%', color: AppColors.teal500),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onRetake,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.green300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Retake', style: TextStyle(color: AppColors.green700, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: save analysis to plant profile
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Add to My Plants', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: AppColors.stone600)),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.teal400.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: AppColors.teal500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13, color: AppColors.stone600)),
          ),
        ],
      ),
    );
  }
}